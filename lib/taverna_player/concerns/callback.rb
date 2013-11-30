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
    module Callback

      extend ActiveSupport::Concern

      def callback(cb, *params)
        if cb.is_a? Proc
          cb.call(*params)
        else
          method(cb).call(*params)
        end
      end

    end
  end
end
