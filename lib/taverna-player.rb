#------------------------------------------------------------------------------
# Copyright (c) 2013, 2014 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Taverna Player was developed in the BioVeL project, funded by the European
# Commission 7th Framework Programme (FP7), through grant agreement
# number 283359.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

require "require_all"
require "coderay"
require "delayed_job_active_record"
require "jbuilder"
require 'mime/types'
require "paperclip"
require "pmrpc-rails"
require "rails_autolink"
require "t2-server"
require "taverna-t2flow"
require "tmpdir"
require "zip"

# Grab everything in the taverna_player directory using the require_all gem.
require_rel "taverna_player"

# This module serves as the configuration point of Taverna Player. Examples of
# all configuration options can be found in the taverna_player initializer.
module TavernaPlayer
  # Configuration without defaults
  mattr_accessor :server_address, :server_password, :server_username

  # This should be set to the name of the workflow model class in the main
  # application via the workflow_model_proxy method below. Defaults to the
  # internal Taverna Player Workflow model (TavernaPlayer::Workflow).
  mattr_reader :workflow_proxy
  @@workflow_proxy =
    ModelProxy.new("TavernaPlayer::Workflow", [:file, :title, :inputs])

  # :call-seq:
  #   workflow_model_proxy = workflow_class
  #   workflow_model_proxy(workflow_class) {|proxy| ...}
  #
  # Set up a proxy to the main application's workflow model. The class name
  # should be supplied as a string, e.g. "Workflow".
  #
  # See the taverna_player initializer for more information.
  def self.workflow_model_proxy(workflow_class)
    @@workflow_proxy = ModelProxy.new(workflow_class, [:file, :title, :inputs])
    yield @@workflow_proxy if block_given?
  end

  # :stopdoc:
  def self.workflow_model_proxy=(workflow_class)
    TavernaPlayer.workflow_model_proxy(workflow_class)
  end
  # :startdoc:

  # This should be set to the name of the user model class in the main
  # application via the user_model_proxy method below. Defaults to nil.
  mattr_reader :user_proxy
  @@user_proxy = nil

  # :call-seq:
  #   user_model_proxy = user_class
  #
  # Set up a proxy to the main application's user model if it has one. The
  # class name should be supplied as a string, e.g. "User".
  #
  # See the taverna_player initializer for more information.
  def self.user_model_proxy=(user_class)
    @@user_proxy = ModelProxy.new(user_class)
  end

  # This should be set to the name of the method used to get the current user
  # in the main app. For Devise this would be :current_user. Defaults to nil.
  mattr_accessor :current_user_callback
  @@current_user_callback = nil

  # Setup default port render callbacks.
  mattr_reader :port_renderer
  @@port_renderer = PortRenderer.new
  @@port_renderer.default(:cannot_inline_tp_default)
  @@port_renderer.list(:list_tp_default)
  @@port_renderer.add("text/plain", :format_text_tp_default, true)
  @@port_renderer.add("text/xml", :format_xml_tp_default)
  @@port_renderer.add("image/jpeg", :show_image_tp_default)
  @@port_renderer.add("image/png", :show_image_tp_default)
  @@port_renderer.add("image/gif", :show_image_tp_default)
  @@port_renderer.add("image/bmp", :show_image_tp_default)
  @@port_renderer.add("application/x-error", :workflow_error_tp_default)
  @@port_renderer.add("application/x-empty", :empty_tp_default)
  @@port_renderer.add("inode/x-empty", :empty_tp_default)

  # :call-seq:
  #   port_renderers {|renderer| ...}
  #
  # Set up the renderers for each MIME type that you want to be able to show
  # in the browser. In most cases the supplied defaults will be sufficient.
  #
  # See the taverna_player initializer for more information.
  def self.port_renderers
    yield @@port_renderer if block_given?
  end

  # Path to place where files should be stored.
  mattr_accessor :file_store
  @@file_store = ":rails_root/public/system"

  # Admin scope for system configuration routes.
  mattr_accessor :admin_scope
  @@admin_scope = ""

  # Taverna server polling interval (in seconds)
  mattr_accessor :server_poll_interval
  @@server_poll_interval = 5

  # Taverna server retry interval (in seconds)
  mattr_accessor :server_retry_interval
  @@server_retry_interval = 10

  # Taverna Server connection parameters
  mattr_accessor :server_connection
  @@server_connection = T2Server::DefaultConnectionParameters.new

  # Queue on which to create workflow execution jobs
  mattr_accessor :job_queue_name
  @@job_queue_name = "player"

  # Pre run callback
  mattr_accessor :pre_run_callback
  @@pre_run_callback = nil

  # Post run callback
  mattr_accessor :post_run_callback
  @@post_run_callback = nil

  # Run cancelled callback
  mattr_accessor :run_cancelled_callback
  @@run_cancelled_callback = nil

  # Run failed callback
  mattr_accessor :run_failed_callback
  @@run_failed_callback = nil

  # :call-seq:
  #   setup {|config| ...}
  #
  # Yield this configuration class so that Taverna Player can be set up.
  #
  # See the taverna_player initializer for more information.
  def self.setup
    yield self
  end

end
