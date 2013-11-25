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
    class ViewsGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../app/views", __FILE__)

      desc "Copy the Taverna Player views and layouts into the main app for "\
        "user customization."

      def copy_views_and_layouts
        directory "taverna_player", "app/views/taverna_player"
        directory "layouts", "app/views/layouts"
      end
    end
  end
end
