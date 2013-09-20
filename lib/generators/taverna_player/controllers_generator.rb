
module TavernaPlayer
  module Generators
    class ControllersGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Copy the Taverna Player controllers into the main app for customization."

      def copy_controllers
        copy_file "runs_controller.rb",
          "app/controllers/taverna_player/runs_controller.rb"

        copy_file "service_credentials_controller.rb",
          "app/controllers/taverna_player/service_credentials_controller.rb"
      end
    end
  end
end
