require "coderay"
require "delayed_job_active_record"
require "paperclip"
require "rails_autolink"
require "t2-server"
require "taverna-t2flow"
require "tmpdir"
require "zip/zip"

require "taverna_player/engine"
require "taverna_player/parser"
require "taverna_player/worker"

module TavernaPlayer
  # Configuration without defaults
  mattr_accessor :server_address, :server_password, :server_username

  # This should be set to the name of the workflow model class in the main app.
  mattr_accessor :workflow_class
  @@workflow_class = "Workflow"

  # Taverna server polling interval (in seconds)
  mattr_accessor :server_poll_interval
  @@server_poll_interval = 5

  # Post run callback
  mattr_accessor :post_run_callback
  @@post_run_callback = nil

  def self.setup
    yield self
  end

  def self.workflow_class
    if @@workflow_class.is_a?(String)
      begin
        Object.const_get(@@workflow_class)
      rescue NameError
        @@workflow_class.constantize
      end
    end
  end

end
