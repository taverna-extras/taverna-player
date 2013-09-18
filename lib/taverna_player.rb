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
require "taverna_player/model_proxy"

module TavernaPlayer
  # Configuration without defaults
  mattr_accessor :server_address, :server_password, :server_username

  # This should be set to the name of the workflow model class in the main
  # application via the workflow_model_proxy method below.
  mattr_reader :workflow_proxy
  def self.workflow_model_proxy(workflow_class)
    @@workflow_proxy = ModelProxy.new(workflow_class, [:file, :title])
    yield @@workflow_proxy if block_given?
  end

  # Taverna server polling interval (in seconds)
  mattr_accessor :server_poll_interval
  @@server_poll_interval = 5

  # Pre run callback
  mattr_accessor :pre_run_callback
  @@pre_run_callback = nil

  # Post run callback
  mattr_accessor :post_run_callback
  @@post_run_callback = nil

  # Run cancelled callback
  mattr_accessor :run_cancelled_callback
  @@run_cancelled_callback = nil

  def self.setup
    yield self
  end

end
