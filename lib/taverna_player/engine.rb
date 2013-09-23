module TavernaPlayer
  class Engine < ::Rails::Engine
    isolate_namespace TavernaPlayer

    initializer "taverna_player.action_controller" do
      ActiveSupport.on_load :action_controller do
        helper TavernaPlayer::ApplicationHelper
      end
    end
  end
end
