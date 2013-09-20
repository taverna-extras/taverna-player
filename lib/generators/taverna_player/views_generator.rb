
module TavernaPlayer
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../app/views", __FILE__)

      desc "Copy the Taverna Player views into the main app for customization."

      def copy_views
        directory "taverna_player", "app/views/taverna_player"
      end
    end
  end
end
