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

  # This class is the superclass of the input and output port types
  # RunPort::Input and RunPort::Output, respectively. It holds much common
  # functionality.
  #
  # A port can hold either a text value or a file.
  class RunPort < ActiveRecord::Base
    include TavernaPlayer::Concerns::Models::RunPort

    ##
    # :method: display_name
    # :call-seq:
    #   display_name -> string
    #
    # Convert this port's name to a more presentable form. In practice this
    # means converting underscores (_) to spaces, while preserving case.

    ##
    # :method: value_preview
    # :call-seq:
    #   value_preview -> string
    #
    # Show up to the first 256 characters of the port's value. This returns
    # nil if the port has a file instead of a value.

    ##
    # :method: value
    # :call-seq:
    #   value -> string
    #
    # Return the value held in this port if there is one.

    ##
    # :method: metadata
    # :call-seq:
    #   metadata -> hash
    #
    # Get the size and type metadata for this port in a Hash. For a list it
    # might look like this:
    #
    #  {
    #    :size => [12, 36509],
    #    :type => ["text/plain", "image/png"]
    #  }
    #
    # <b>Note:</b> By default Taverna Player only uses this field on outputs.
    # It is provided as a field for inputs too as a convenience for
    # implementors and for possible future use.

  end

  # This class represents a workflow input port. All functionality is provided
  # by the RunPort superclass.
  class RunPort::Input < RunPort
    include TavernaPlayer::Concerns::Models::Input
  end

  # This class represents a workflow output port. All functionality is
  # provided by the RunPort superclass.
  class RunPort::Output < RunPort
    include TavernaPlayer::Concerns::Models::Output
  end
end
