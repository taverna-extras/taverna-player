#------------------------------------------------------------------------------
# Copyright (c) 2013, 2014 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Taverna Player was developed in the BioVeL project, funded by the European
# Commission 7th Framework Programme (FP7), through grant agreement
# number 283359.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

def player_pre_run_callback(run)
  w = TavernaPlayer::Workflow.find(run.workflow_id)
  puts "Pre-run callback called for run '#{run.name}' of workflow '#{w.id}'"
end

def player_post_run_callback(run)
  w = TavernaPlayer::Workflow.find(run.workflow_id)
  puts "Post-run callback called for run '#{run.name}' of workflow '#{w.id}'"
end

def player_run_cancelled_callback(run)
  w = TavernaPlayer::Workflow.find(run.workflow_id)
  puts "Run-cancelled callback called for run '#{run.name}' of workflow '#{w.id}'"
end

def player_run_failed_callback(run)
  w = TavernaPlayer::Workflow.find(run.workflow_id)
  puts "Run-failed callback called for run '#{run.name}' of workflow '#{w.id}'"
end
