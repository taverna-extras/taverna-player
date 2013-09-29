
module TavernaPlayer
  module Generators
    class RenderersGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Create some basic renderer callbacks in "\
        "'lib/taverna_player_renderers.rb'"

      def copy_callbacks
        copy_file "render_callbacks.rb", "lib/taverna_player_renderers.rb"
      end
    end
  end
end
