module TavernaPlayer

  # These helpers will be available in the main application when you use
  # Taverna Player.
  module ApplicationHelper

    # :call-seq:
    #   new_embedded_run_path(workflow) -> string
    #
    # Given a workflow instance, or workflow id, this method returns the URI
    # path to a new embedded run of that workflow.
    def new_embedded_run_path(id_or_model)
      id = workflow_id(id_or_model)

      raw(taverna_player.new_run_path(:workflow_id => id, :embedded => true))
    end

    # :call-seq:
    #   new_embedded_run_url(workflow) -> string
    #
    # Given a workflow instance, or workflow id, this method returns the full
    # URI to a new embedded run of that workflow.
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
