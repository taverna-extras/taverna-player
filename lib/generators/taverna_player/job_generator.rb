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
  module Generators
    class JobGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../script", __FILE__)

      desc "Installs the delayed_job script, if required"

      def copy_job_script
        copy_file "delayed_job",
          "script/delayed_job"
      end
    end
  end
end
