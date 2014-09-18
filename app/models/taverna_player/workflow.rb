#------------------------------------------------------------------------------
# Copyright (c) 2013, 2014 The University of Manchester, UK.
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

  # This class represents a workflow. It is provided as an example model and
  # can be extended or replaced as required.
  #
  # To replace the model completely please read about configuring the workflow
  # model proxy in the "Taverna Player initializers" section of the ReadMe. To
  # extend the model please read about "Overriding the default models and
  # controllers" in the ReadMe.
  class Workflow < ActiveRecord::Base
    include TavernaPlayer::Concerns::Models::Workflow

    ##
    # :method: inputs
    # :call-seq:
    #   inputs -> Hash
    #
    # Return a hash of information about this workflow's inputs. The fields
    # provided are:
    # * <tt>:name</tt> - The name of the input port.
    # * <tt>:description</tt> - A textual description (if provided) of the
    #   input port.
    # * <tt>:example</tt> - Example input data (if provided) for the input
    #   port.
    #
    # All data is read directly from the workflow file itself.

  end
end
