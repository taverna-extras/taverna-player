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
  class Workflow < ActiveRecord::Base
    # Do not remove the next line.
    include TavernaPlayer::Concerns::Models::Workflow

    # Extend the Workflow model here.
  end
end
