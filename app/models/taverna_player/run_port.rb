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
    # :method: value_size
    # :call-seq:
    #   value_size -> string
    #   value_size(indices) -> string
    #
    # Get the size (in bytes) of the value held in this port. Pass in a list
    # of indices if it is a list port. Returns nil if there is no port
    # metadata.

    ##
    # :method: value_type
    # :call-seq:
    #   value_type -> string
    #   value_type(indices) -> string
    #
    # Get the MIME type of the value held in this port. Pass in a list of
    # indices if it is a list port. Returns "text/plain" if there is no port
    # metadata so if you create a port and put any other type of data in then
    # you should adjust the metadata to match.

    ##
    # :method: value_is_text?
    # :call-seq:
    #   value_is_text? -> string
    #   value_is_text?(indices) -> string
    #
    # Is the type of the value held in this port some sort of text? This
    # returns true if the media type section of the MIME type is "text". Pass
    # in a list of indices if it is a list port.

    ##
    # :method: value
    # :call-seq:
    #   value -> string
    #   value(indices) -> string
    #
    # Return the value held in this port if there is one. Pass in a list of
    # indices if it is a list port.
    #
    # For a port of depth 0:
    #
    #  value = output.value
    #
    # For a port of depth 2:
    #
    #  value = output.value(0, 0)
    #  value = output.value([1, 2])
    #
    # Trying to get a list value out of a port of depth 0 will simply return
    # the port's value.

    ##
    # :method: path
    # :call-seq:
    #   path -> string
    #   path(indices) -> string
    #
    # Return a url path segment that addresses this output value. Pass in a
    # list of indices if it is a list port.
    #
    # For a port of depth 0 called "OUT":
    #
    #  path = output.path # => "/runs/1/output/OUT"
    #
    # For a port of depth 2 called "OUT_LIST":
    #
    #  path = output.path(0, 0) # => "runs/1/output/OUT_LIST/0/0"
    #  path = output.path([1, 2]) # => "runs/1/output/OUT_LIST/1/2"

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
