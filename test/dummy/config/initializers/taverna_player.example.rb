# Taverna Player configuration

TavernaPlayer.setup do |config|
  # This should be set to the name of the workflow model class in the main app.
  #config.workflow_class = "Workflow"

  # Taverna Server configuration information. The poll interval is in seconds.
  config.server_address = "http://localhost:8080/taverna"
  config.server_username = "taverna"
  config.server_password = "taverna"
  config.server_poll_interval = 5
end
