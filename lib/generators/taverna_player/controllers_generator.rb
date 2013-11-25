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
  module Generators
    class ControllersGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/controllers", __FILE__)

      desc "Copy the Taverna Player controllers into the main app for "\
        "customization."

      def copy_controllers
        copy_file "runs_controller.rb",
          "app/controllers/taverna_player/runs_controller.rb"

        copy_file "service_credentials_controller.rb",
          "app/controllers/taverna_player/service_credentials_controller.rb"
      end
    end
  end
end
