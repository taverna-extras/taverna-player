
module TavernaPlayer
  module Generators
    class ModelsGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/models", __FILE__)

      desc "Copy the Taverna Player models into the main app for "\
        "customization."

      def copy_models
        copy_file "run.rb",
          "app/models/taverna_player/run.rb"
      end
    end
  end
end
