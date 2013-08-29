# Taverna Player configuration

TavernaPlayer.setup do |config|
  # This should be set to the name of the workflow model class in the main app.
  #config.workflow_class = "Workflow"

  # Taverna Server configuration information. The poll interval is in seconds.
  config.server_address = "http://localhost:8080/taverna"
  config.server_username = "taverna"
  config.server_password = "taverna"
  config.server_poll_interval = 5

  # Callbacks to be run at various points during a workflow run. These can be
  # defined as Proc objects or as methods and referenced by name.
  #
  # Be careful! If a callback fails then the worker running the job will fail!
  #
  # Add callbacks in this initializer or define them elsewhere and require the
  # file as usual (if they are not pulled in by some other code).
  #require "callbacks" # See lib/callbacks.rb for these examples.

  # The post-run callback is called after the run has completed normally.
  # It takes the run model object as its parameter.
  #config.post_run_callback = Proc.new { |run| puts "Finished: #{run.name}" }
  #config.post_run_callback = "player_post_run_callback"
  #config.post_run_callback = :player_post_run_callback
end

# Example callbacks defined in the initializer.

#def player_post_run_callback(run)
#  puts "Finished: #{run.name}"
#end
