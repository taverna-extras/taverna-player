module TavernaPlayer
  class Interaction < ActiveRecord::Base
    attr_accessible :displayed, :feed_reply, :output_value, :page, :replied,
      :unique_id

    belongs_to :run, :class_name => "TavernaPlayer::Run"

    validates_presence_of :unique_id
    validates_uniqueness_of :unique_id
  end
end
