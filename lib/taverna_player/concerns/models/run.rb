
module TavernaPlayer
  module Concerns
    module Models
      module Run

        extend ActiveSupport::Concern

        included do
          attr_accessible :create_time, :delayed_job, :embedded, :finish_time,
            :inputs_attributes, :log, :name, :proxy_interactions,
            :proxy_notifications, :results, :run_id, :start_time,
            :status_message, :workflow_id

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

          has_attached_file :log,
            :path => ":rails_root/public/system/:class/:attachment/:id/:filename",
            :url => "/system/:class/:attachment/:id/:filename",
            :default_url => ""

          has_attached_file :results,
            :path => ":rails_root/public/system/:class/:attachment/:id/:filename",
            :url => "/system/:class/:attachment/:id/:filename",
            :default_url => ""

          after_create :enqueue

          private

          def enqueue
            worker = TavernaPlayer::Worker.new(self)
            job = Delayed::Job.enqueue worker, :queue => "player"
            update_attributes(:delayed_job => job, :status_message => "Queued")
          end

        end # included

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
      end
    end
  end
end
