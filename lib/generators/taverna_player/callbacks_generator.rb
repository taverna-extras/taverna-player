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
    class CallbacksGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/callbacks", __FILE__)

      desc "Create some basic callbacks in 'lib/taverna_player_callbacks.rb'"

      def copy_callbacks
        copy_file "worker_callbacks.rb", "lib/taverna_player_callbacks.rb"
      end
    end
  end
end
