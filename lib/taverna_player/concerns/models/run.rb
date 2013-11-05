
module TavernaPlayer
  module Concerns
    module Models
      module Run

        extend ActiveSupport::Concern

        included do
          attr_accessible :create_time, :delayed_job, :embedded, :finish_time,
            :inputs_attributes, :log, :name, :parent_id, :results, :run_id,
            :start_time, :status_message, :workflow_id

          # Each run is spawned from a workflow. This provides the link to the
          # workflow model in the parent app, whatever it calls its model.
          belongs_to :workflow, :class_name => TavernaPlayer.workflow_proxy.class_name.to_s

          has_many :inputs, :class_name => "TavernaPlayer::RunPort::Input",
            :dependent => :destroy
          has_many :outputs, :class_name => "TavernaPlayer::RunPort::Output",
            :dependent => :destroy
          has_many :interactions, :class_name => "TavernaPlayer::Interaction",
            :dependent => :destroy
          belongs_to :delayed_job, :class_name => "::Delayed::Job"

          # A run can have children, which are runs.
          # A run can have a parent, which is another run.
          has_many :children, :class_name => "TavernaPlayer::Run",
            :foreign_key => "parent_id"
          belongs_to :parent, :class_name => "TavernaPlayer::Run"

          accepts_nested_attributes_for :inputs

          STATES = ["pending", "initialized", "running", "finished", "cancelled", "failed"]

          validates :workflow_id, :presence => true
          validates :name, :presence => true

          # There is a :cancelled state but it can only be set if the run has
          # previously had its stop flag set. This is to avoid race conditions.
          # If we used a state to tell the delayed job worker to cancel a run
          # it could be overwritten when the worker itself moves the run
          # between states, thus losing the cancel request from the user.
          validates :saved_state, :inclusion => { :in => STATES }
          validates :stop, :presence => true, :if => :cancelled?

          # A parent must have an "older" run id than its children. This only
          # needs to be checked on update because on create we don't have an
          # id for ourself.
          validates :parent_id, :numericality => { :less_than => :id,
              :message => "Parents must have lower ids than children" },
            :allow_nil => true, :on => :update

          has_attached_file :log,
            :path => ":rails_root/public/system/:class/:attachment/:id/:filename",
            :url => "/runs/:id/download/log",
            :default_url => ""

          has_attached_file :results,
            :path => ":rails_root/public/system/:class/:attachment/:id/:filename",
            :url => "/runs/:id/download/results",
            :default_url => ""

          after_initialize :initialize_child_run, :if => :has_parent?
          after_create :populate_child_inputs, :if => :has_parent?
          after_create :enqueue
          before_destroy :complete?

          private

          # A child run MUST have the same workflow as its parent.
          def initialize_child_run
            self.workflow = parent.workflow
          end

          # For each input on the parent run, make sure we have an equivalent
          # on the child. Copy the values/files of inputs that are missing.
          def populate_child_inputs
            parent.inputs.each do |i|
              input = TavernaPlayer::RunPort::Input.find_or_initialize_by_run_id_and_name(id, i.name)
              if input.new_record?
                input.value = i.value
                input.file = i.file
                input.depth = i.depth
                input.save
              end
            end
          end

          def enqueue
            worker = TavernaPlayer::Worker.new(self)
            job = Delayed::Job.enqueue worker, :queue => "player"
            update_attributes(:delayed_job => job, :status_message => "Queued")
          end

        end # included

        # Get the original ancestor of this run. In practice this is the first
        # run in the chain without a parent.
        def root_ancestor
          has_parent? ? parent.root_ancestor : self
        end

        # There are two courses of action here:
        #
        # * If the run is already running then cancel this run by setting the
        #   stop flag. This is done to allow the delayed job that is
        #   monitoring the run to delete it and clean up Taverna Server
        #   gracefully.
        # * If the run is still in the queue, destroy the queue object. This
        #   is checked in a transaction so that we don't get hit with a race
        #   condition between checking the queued status of the run and
        #   actually removing it from the queue.
        #
        # In both cases the stop flag is set to mark the run as cancelled
        # internally.
        #
        # See the note above about the :cancelled state.
        def cancel
          return if complete?

          # If the run has a delayed job (still) and it hasn't been locked yet
          # then we just remove it from the queue directly and mark the run as
          # cancelled.
          unless delayed_job.nil?
            delayed_job.with_lock do
              if delayed_job.locked_by.nil?
                delayed_job.destroy
                update_attribute(:saved_state, "cancelled")
                update_attribute(:status_message, "Cancelled")
              end
            end
          end

          update_attribute(:stop, true)
        end

        # Return state as a symbol.
        def state
          self[:saved_state].to_sym
        end

        # Save state as a downcased string. See the note above about why a
        # state cannot be used to actually cancel a run.
        def state=(state)
          s = state.to_s.downcase
          return if s == "cancelled" && !stop
          self[:saved_state] = s
        end

        def running?
          state == :running
        end

        def finished?
          state == :finished
        end

        def cancelled?
          state == :cancelled
        end

        def failed?
          state == :failed
        end

        # This is used as a catch-all for finished, cancelled and failed
        def complete?
          finished? || cancelled? || failed?
        end

        def has_parent?
          !parent_id.nil?
        end
      end
    end
  end
end
