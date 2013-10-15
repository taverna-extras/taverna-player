module TavernaPlayer
  module ApplicationHelper

    def new_embedded_run_path(id_or_model)
      id = workflow_id(id_or_model)

      raw(taverna_player.new_run_path(:workflow_id => id, :embedded => true))
    end

    def new_embedded_run_url(id_or_model)
      id = workflow_id(id_or_model)

      raw(taverna_player.new_run_url(:workflow_id => id, :embedded => true))
    end

    private

    def workflow_id(id_or_model)
      case id_or_model
      when TavernaPlayer::Run
        id_or_model.workflow_id
      when TavernaPlayer.workflow_proxy.class_name
        id_or_model.id
      else
        id_or_model
      end
    end

  end
end
