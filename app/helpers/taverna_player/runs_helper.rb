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
  module RunsHelper

    def interaction_redirect(interaction)
      if interaction.page_uri.blank?
        run_url(interaction.run) + "/interaction/#{interaction.serial}"
      else
        interaction.page_uri
      end
    end

  end
end
