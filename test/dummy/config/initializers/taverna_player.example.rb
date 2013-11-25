#------------------------------------------------------------------------------
# Copyright (c) 2013 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Taverna Player was developed in the BioVeL project, funded by the European
# Commission 7th Framework Programme (FP7), through grant agreement
# number 283359.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

# Taverna Player configuration

TavernaPlayer.setup do |config|
  # This should be set to the name of the workflow model class in the main
  # application and the listed methods should also be mapped if necessary.
  config.workflow_model_proxy("Workflow")

  config.user_model_proxy = "User"
  config.current_user_callback = :user_one

  # Taverna Server configuration information. The poll interval is in seconds.
  config.server_address = "https://example.com:8443/tavserv"
  config.server_username = "taverna"
  config.server_password = "taverna"
  config.server_poll_interval = 1
  config.server_retry_interval = 10

  # Taverna Server connection configuration.
  config.server_connection[:open_timeout] = 10

  # Callbacks to be run at various points during a workflow run.
  require "callbacks"

  config.pre_run_callback = :player_pre_run_callback
  config.post_run_callback = :player_post_run_callback
  config.run_cancelled_callback = :player_run_cancelled_callback
  config.run_failed_callback = :player_run_failed_callback
end
