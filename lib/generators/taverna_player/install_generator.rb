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
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Taverna Player initializer"

      def copy_initializer
        copy_file "initializer.rb",
          "config/initializers/taverna_player.rb.example"
      end

      def show_readme
        readme "ReadMe.txt" if behavior == :invoke
      end
    end
  end
end
