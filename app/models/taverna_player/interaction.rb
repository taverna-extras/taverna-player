module TavernaPlayer
  class Interaction < ActiveRecord::Base
    attr_accessible :displayed, :feed_reply, :page, :replied, :unique_id

    belongs_to :run, :class_name => "TavernaPlayer::Run"

    validates_presence_of :unique_id
    validates_uniqueness_of :unique_id
    validates_presence_of :serial
    validates_uniqueness_of :serial, :scope => :run_id,
      :message => "Interaction serial number should be unique for a run"
  end
end
