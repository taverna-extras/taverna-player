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
  module Concerns
    module Utils

      extend ActiveSupport::Concern

      # Taverna can have arbitrary (therefore effectively "infinite") port
      # depths so we need to recurse into them. This code is common across a
      # number of other modules.
      def recurse_into_lists(list, indexes)
        return list if indexes.empty? || !list.is_a?(Array)
        i = indexes.shift
        recurse_into_lists(list[i], indexes)
      end

    end
  end
end
