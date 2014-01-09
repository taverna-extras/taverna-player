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

require 'test_helper'

class WorkerTest < ActiveSupport::TestCase

  setup do
    @worker = TavernaPlayer::Worker.new(taverna_player_runs(:one))
  end

  test "max attempts should be 1" do
    assert_equal 1, @worker.max_attempts, "Max attempts was not 1."
  end

end
