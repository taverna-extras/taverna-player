module TavernaPlayer
  class Interaction < ActiveRecord::Base
    attr_accessible :displayed, :replied, :uri

    validates_presence_of :uri
  end
end
