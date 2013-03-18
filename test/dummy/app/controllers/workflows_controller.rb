class WorkflowsController < ApplicationController
  def index
    @workflows = Workflow.all
  end
end
