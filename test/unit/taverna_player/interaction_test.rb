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

require 'test_helper'

module TavernaPlayer
  class InteractionTest < ActiveSupport::TestCase
    test "should not save interaction without a serial number" do
      int = Interaction.new
      refute int.save, "Saved the interaction without a serial number"
    end

    test "should not allow two identical serial numbers for the same run" do
      int = Interaction.new
      int.serial = "ask0"
      int.run = taverna_player_runs(:four)
      refute int.save, "Saved the interaction with a non-unique serial number"
    end

    test "replied defaults to false" do
      int = Interaction.new
      refute int.replied, "Interaction#replied did not default to false"
    end

    test "displayed defaults to false" do
      int = Interaction.new
      refute int.displayed, "Interaction#displayed did not default to false"
    end
  end
end
