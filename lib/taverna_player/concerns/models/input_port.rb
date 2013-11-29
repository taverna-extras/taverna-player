#------------------------------------------------------------------------------
# Copyright (c) 2013 The University of Manchester, UK.
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
    module Models
      module Input

        extend ActiveSupport::Concern

        included do
          belongs_to :run, :class_name => "TavernaPlayer::Run",
            :inverse_of => :inputs

          private

          def file_url_via_run
            "/runs/#{run_id}/input/#{name}"
          end
        end # included

      end
    end
  end
end
