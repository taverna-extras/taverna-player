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
      module JobQueueController

        extend ActiveSupport::Concern

        included do
          respond_to :html

          before_filter :find_jobs

          def find_jobs
            @jobs = Delayed::Job.find_all_by_queue(TavernaPlayer.job_queue_name)
          end
        end # included

        # GET job_queue
        def index

        end

      end
    end
  end
end
