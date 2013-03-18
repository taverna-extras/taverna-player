require "taverna_player/engine"
require "taverna_player/parser"

module TavernaPlayer
  mattr_accessor :workflow_class

  class << self
    def workflow_class
      if @@workflow_class.is_a?(String)
        begin
          Object.const_get(@@workflow_class)
        rescue NameError
          @@workflow_class.constantize
        end
      end
    end
  end
end
