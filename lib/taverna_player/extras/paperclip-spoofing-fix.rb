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

# We need to override the default Paperclip spoofing detector because it does
# not allow us to have arbitrary file extensions on files.
#
# See https://github.com/thoughtbot/paperclip/issues/1470 and many others.
module Paperclip
  class MediaTypeSpoofDetector
    alias :original_spoofed? :spoofed?

    def spoofed?
      original_spoofed? ? !(calculated_content_type == "text/plain") : false
    end
  end
end
