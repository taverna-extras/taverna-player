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
    module Zip

      extend ActiveSupport::Concern

      def read_file_from_zip(zip, file)
        ::Zip::ZipFile.open(zip) do |z|
          z.read(file)
        end
      end

    end
  end
end
