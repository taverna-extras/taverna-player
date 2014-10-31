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
  module Generators
    class ControllersGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/controllers", __FILE__)

      desc "Copy the Taverna Player controllers into the main app for "\
        "customization."

      def copy_controllers
        %w(runs service_credentials workflows).each do |file|
          copy_file "#{file}_controller.rb",
            "app/controllers/taverna_player/#{file}_controller.rb"
        end
      end
    end
  end
end
