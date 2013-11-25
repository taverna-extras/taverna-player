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

module TavernaPlayer
  class Engine < ::Rails::Engine
    isolate_namespace TavernaPlayer

    initializer "taverna_player.action_controller" do
      ActiveSupport.on_load :action_controller do
        helper TavernaPlayer::ApplicationHelper
      end
    end
  end
end
