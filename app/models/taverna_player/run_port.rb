module TavernaPlayer
  class RunPort < ActiveRecord::Base
    self.inheritance_column = "port_type"

    validates_presence_of :name

    attr_accessible :depth, :file, :name, :value

    has_attached_file :file,
      :path => ":rails_root/public/system/:class/:attachment/:id/:filename",
      :url => "/system/:class/:attachment/:id/:filename",
      :default_url => ""
  end

  class RunPort::Input < RunPort
  end

  class RunPort::Output < RunPort
    attr_accessible :metadata

    serialize :metadata
  end
end
