module TavernaPlayer
  class RunPort < ActiveRecord::Base
    self.inheritance_column = "port_type"

    validates_presence_of :name

    attr_accessible :file, :name, :value
  end

  class RunPort::Input < RunPort
  end

  class RunPort::Output < RunPort
  end
end
