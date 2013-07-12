require "coderay"
require "delayed_job_active_record"
require "paperclip"
require "t2-server"
require "taverna-t2flow"
require "tmpdir"
require "zip/zip"

require "taverna_player/engine"
require "taverna_player/parser"
require "taverna_player/worker"

module TavernaPlayer
  mattr_accessor :server_address, :server_password, :server_poll_interval,
    :server_username, :workflow_class

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
