# Dummy callbacks

def player_pre_run_callback(run)
  w = Workflow.find(run.workflow_id)
  puts "Pre-run callback called for run '#{run.name}' of workflow '#{w.id}'"
end

def player_post_run_callback(run)
  w = Workflow.find(run.workflow_id)
  puts "Post-run callback called for run '#{run.name}' of workflow '#{w.id}'"
end

def player_run_cancelled_callback(run)
  w = Workflow.find(run.workflow_id)
  puts "Run-cancelled callback called for run '#{run.name}' of workflow '#{w.id}'"
end
