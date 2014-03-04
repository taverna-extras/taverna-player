#------------------------------------------------------------------------------
# Copyright (c) 2014 The University of Manchester, UK.
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
  class JobQueueController < TavernaPlayer::ApplicationController
    # See lib/taverna_player/concerns/controllers/job_queue_controller.rb
    include TavernaPlayer::Concerns::Controllers::JobQueueController
  end
end
