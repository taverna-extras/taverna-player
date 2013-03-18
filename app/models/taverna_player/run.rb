module TavernaPlayer
  class Run < ActiveRecord::Base
    attr_accessible :create_time, :finish_time, :run_id, :start_time,
      :workflow_id, :inputs_attributes

    has_many :inputs, :class_name => TavernaPlayer::RunPort::Input, :dependent => :destroy
    has_many :outputs, :class_name => TavernaPlayer::RunPort::Output, :dependent => :destroy

    accepts_nested_attributes_for :inputs

    STATES = [:pending, :initialized, :running, :finished, :deleted]

    validates :workflow_id, :presence => true
    validates :state, :inclusion => { :in => STATES }

    # Return state as a symbol.
    def state
      self[:state].to_sym
    end

    # Save state as a downcased string.
    def state=(state)
      self[:state] = state.to_s.downcase
    end
  end
end
