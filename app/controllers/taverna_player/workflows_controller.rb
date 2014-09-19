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

module TavernaPlayer
  class WorkflowsController < TavernaPlayer::ApplicationController
    # See lib/taverna_player/concerns/controllers/workflows_controller.rb
    include TavernaPlayer::Concerns::Controllers::WorkflowsController
  end
end
