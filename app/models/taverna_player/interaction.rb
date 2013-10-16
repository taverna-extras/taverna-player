module TavernaPlayer
  class Interaction < ActiveRecord::Base
    attr_accessible :displayed, :feed_reply, :output_value, :page, :replied,
      :unique_id

    validates_presence_of :unique_id
    validates_uniqueness_of :unique_id
  end
end
