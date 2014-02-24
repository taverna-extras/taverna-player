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
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates Taverna Player initializers"

      def copy_initializers
        copy_file "player_initializer.rb",
          "config/initializers/taverna_player.rb"

        copy_file "server_initializer.rb",
          "config/initializers/taverna_server.rb.example"
      end

      def copy_locale
        copy_file "../../../config/locales/en.yml",
          "config/locales/taverna_player.en.yml"
      end

      def show_readme
        readme "ReadMe.txt" if behavior == :invoke
      end
    end
  end
end
