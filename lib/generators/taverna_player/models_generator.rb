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
    class ModelsGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/models", __FILE__)

      desc "Copy the Taverna Player models into the main app for "\
        "customization."

      def copy_models
        ["run.rb", "run_port.rb"].each do |file|
          copy_file file, "app/models/taverna_player/#{file}"
        end
      end
    end
  end
end
