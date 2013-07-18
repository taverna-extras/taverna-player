module TavernaPlayer
  class Run < ActiveRecord::Base
    attr_accessible :create_time, :embedded, :finish_time, :inputs_attributes,
      :proxy_interactions, :proxy_notifications, :results, :run_id,
      :start_time, :status_message, :workflow_id

    has_many :inputs, :class_name => TavernaPlayer::RunPort::Input, :dependent => :destroy
    has_many :outputs, :class_name => TavernaPlayer::RunPort::Output, :dependent => :destroy
    has_many :interactions, :class_name => TavernaPlayer::Interaction, :dependent => :destroy

    accepts_nested_attributes_for :inputs

    # There is a very good reason that we don't have a :cancelled state and
    # use the stop flag instead: Race conditions. If we used a state for this
    # it could be overwritten by the delayed job as it moves the run between
    # states, thus losing the cancel request from the user.
    STATES = [:pending, :initialized, :running, :finished, :deleted]

    validates :workflow_id, :presence => true
    validates :state, :inclusion => { :in => STATES }

    has_attached_file :results,
      :path => ":rails_root/public/system/:class/:attachment/:id/:filename",
      :url => "/system/:class/:attachment/:id/:filename",
      :default_url => ""

    # Cancel this run by setting the stop flag. This is done to allow the
    # delayed job that is monitoring the run to delete it gracefully.
    # See the note above about the (lack of a) :cancelled state.
    def cancel
      return if finished? || cancelled?
      update_attribute(:stop, true)
    end

    # Return state as a symbol. See the note above about the (lack of a)
    # :cancelled state.
    def state
      return :cancelled if self[:stop]
      self[:state].to_sym
    end

    # Save state as a downcased string.
    def state=(state)
      self[:state] = state.to_s.downcase
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
