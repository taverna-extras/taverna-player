module TavernaPlayer
  class RunPort < ActiveRecord::Base
    self.inheritance_column = "port_type"

    belongs_to :run, :class_name => "TavernaPlayer::Run"

    validates_presence_of :name
    validates_uniqueness_of :name, :scope => [:run_id, :port_type]

    attr_accessible :depth, :name, :value

    default_scope order("lower(name) ASC")
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
