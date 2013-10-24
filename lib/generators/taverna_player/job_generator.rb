
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
