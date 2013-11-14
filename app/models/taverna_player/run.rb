module TavernaPlayer

  # This class represents a workflow run. It may be yet to run, running or
  # finished. All inputs and outputs can be accessed via this class.
  class Run < ActiveRecord::Base
    include TavernaPlayer::Concerns::Models::Run

    ##
    # :method: create_time
    # :call-seq:
    #   create_time -> datetime
    #
    # The time this run was created on the Taverna Server.

    ##
    # :method: cancelled?
    # :call-seq:
    #   cancelled? -> boolean
    #
    # Has this run been cancelled?

    ##
    # :method: complete?
    # :call-seq:
    #   complete? -> boolean
    #
    # Is this run complete? If a run is finished or cancelled or failed then
    # it is complete.

    ##
    # :method: embedded?
    # :call-seq:
    #   embedded? -> boolean
    #
    # Is this run an embedded run? This helps determine if a run should be
    # treated differently, e.g. in the views, if it is running embedded within
    # another location or website.

    ##
    # :method: failed?
    # :call-seq:
    #   failed? -> boolean
    #
    # Did this run finish abnormally or with an error?

    ##
    # :method: finish_time
    # :call-seq:
    #   finish_time -> datetime
    #
    # The time this run finished running on Taverna Server.

    ##
    # :method: finished?
    # :call-seq:
    #   finished? -> boolean
    #
    # Has this run finished normally?

    ##
    # :method: has_parent?
    # :call-seq:
    #   has_parent? -> boolean
    #
    # A run will have a parent if it is a child run as part of a sweep.

    ##
    # :method: name
    # :call-seq:
    #   name -> string
    #
    # The name (mnemonic) of this run.

    ##
    # :method: root_ancestor
    # :call-seq:
    #   root_ancestor -> run
    #
    # Gets the ultimate ancestor of this run, which may not be its immediate
    # parent.

    ##
    # :method: running?
    # :call-seq:
    #   running? -> boolean
    #
    # Is this run still running on Taverna Server?

    ##
    # :method: start_time
    # :call-seq:
    #   start_time -> datetime
    #
    # The time this run started running on the Taverna Server.

    ##
    # :method: state
    # :call-seq:
    #   state -> symbol
    #
    # The state of this run. Possible states are :pending, :initialized,
    # :running, :finished, :cancelled or :failed.

  end
end
