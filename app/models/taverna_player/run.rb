module TavernaPlayer
  class Run < ActiveRecord::Base
    attr_accessible :create_time, :delayed_job_id, :embedded, :finish_time,
      :inputs_attributes, :log, :name, :proxy_interactions,
      :proxy_notifications, :results, :run_id, :start_time, :status_message,
      :workflow_id

    has_many :inputs, :class_name => TavernaPlayer::RunPort::Input, :dependent => :destroy
    has_many :outputs, :class_name => TavernaPlayer::RunPort::Output, :dependent => :destroy
    has_many :interactions, :class_name => TavernaPlayer::Interaction, :dependent => :destroy
    belongs_to :delayed_job, :class_name => Delayed::Job

    accepts_nested_attributes_for :inputs

    # There is a very good reason that we don't have a :cancelled state and
    # use the stop flag instead: Race conditions. If we used a state for this
    # it could be overwritten by the delayed job as it moves the run between
    # states, thus losing the cancel request from the user.
    STATES = ["pending", "initialized", "running", "finished", "deleted"]

    validates :workflow_id, :presence => true
    validates :name, :presence => true
    validates :saved_state, :inclusion => { :in => STATES }

    has_attached_file :log,
      :path => ":rails_root/public/system/:class/:attachment/:id/:filename",
      :url => "/system/:class/:attachment/:id/:filename",
      :default_url => ""

    has_attached_file :results,
      :path => ":rails_root/public/system/:class/:attachment/:id/:filename",
      :url => "/system/:class/:attachment/:id/:filename",
      :default_url => ""

    # There are two courses of action here:
    #
    # * If the run is already running then cancel this run by setting the stop
    #   flag. This is done to allow the delayed job that is monitoring the run
    #   to delete it and clean up Taverna Server gracefully.
    # * If the run is still in the queue, destroy the queue object. This is
    #   checked in a transaction so that we don't get hit with a race
    #   condition between checking the queued status of the run and actually
    #   removing it from the queue.
    #
    # In both cases the stop flag is set to mark the run as cancelled
    # internally.
    #
    # See the note above about the (lack of a) :cancelled state.
    def cancel
      return if finished? || cancelled?

      Delayed::Job.transaction do
        if delayed_job.locked_by.nil?
          delayed_job.destroy
          update_attribute(:status_message, "Cancelled")
        end
      end

      update_attribute(:stop, true)
    end

    # Return state as a symbol. See the note above about the (lack of a)
    # :cancelled state.
    def state
      return :cancelled if self[:stop]
      self[:saved_state].to_sym
    end

    # Save state as a downcased string.
    def state=(state)
      self[:saved_state] = state.to_s.downcase
    end

    def running?
      state == :running
    end

    def finished?
      state == :finished
    end

    # See the note above about the (lack of a) :cancelled state.
    def cancelled?
      self[:stop]
    end
  end
end
