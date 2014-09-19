#------------------------------------------------------------------------------
# Copyright (c) 2014 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Taverna Player was developed in the BioVeL project, funded by the European
# Commission 7th Framework Programme (FP7), through grant agreement
# number 283359.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

module TavernaPlayer
  module Concerns
    module Controllers
      module WorkflowsController

        extend ActiveSupport::Concern

        included do
          respond_to :html, :json

          before_filter :find_workflows, :only => :index

          private

          def find_workflows
            @workflows = Workflow.all
          end

        end # included

        # GET /workflows
        def index

        end

      end
    end
  end
end
