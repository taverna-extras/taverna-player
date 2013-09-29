
module TavernaPlayer
  module Generators
    class CallbacksGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Create some basic callbacks in 'lib/taverna_player_callbacks.rb'"

      def copy_callbacks
        copy_file "worker_callbacks.rb", "lib/taverna_player_callbacks.rb"
      end
    end
  end
end
