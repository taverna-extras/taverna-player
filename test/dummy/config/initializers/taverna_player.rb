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

# Taverna Player configuration

TavernaPlayer.setup do |config|
  config.workflow_model_proxy("TavernaPlayer::Workflow") do |proxy|
    proxy.file_method_name = :file
  end
  config.user_model_proxy = "User"
  config.current_user_callback =
    Proc.new { User.find(ActiveRecord::Fixtures.identify(:test_user)) }

  # Move admin resources into their own namespace.
  config.admin_scope = "admin"

  # Callbacks to be run at various points during a workflow run.
  require "callbacks"

  config.pre_run_callback = :player_pre_run_callback
  config.post_run_callback = :player_post_run_callback
  config.run_cancelled_callback = :player_run_cancelled_callback
  config.run_failed_callback = :player_run_failed_callback
end
