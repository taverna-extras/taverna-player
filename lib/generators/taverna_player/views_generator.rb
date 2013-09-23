
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
