module TavernaPlayer
  module ApplicationHelper

    def new_embedded_run_path(workflow_id)
      taverna_player.new_run_path(:workflow_id => workflow_id, :embedded => true)
    end

    def new_embedded_run_url(workflow_id)
      taverna_player.new_run_url(:workflow_id => workflow_id, :embedded => true)
    end

  end
end
