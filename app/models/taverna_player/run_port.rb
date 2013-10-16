module TavernaPlayer
  class RunPort < ActiveRecord::Base
    self.inheritance_column = "port_type"

    belongs_to :run, :class_name => "TavernaPlayer::Run"

    validates_presence_of :name

    attr_accessible :depth, :name, :value
  end

  class RunPort::Input < RunPort
    attr_accessible :file

    has_attached_file :file,
      :path => ":rails_root/public/system/:class/:attachment/:id/:filename",
      :url => "/system/:class/:attachment/:id/:filename",
      :default_url => ""
  end

  class RunPort::Output < RunPort
    attr_accessible :metadata

    serialize :metadata
  end
end
