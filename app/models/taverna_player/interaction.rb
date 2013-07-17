module TavernaPlayer
  class Interaction < ActiveRecord::Base
    attr_accessible :replied, :uri

    validates_presence_of :uri
  end
end
