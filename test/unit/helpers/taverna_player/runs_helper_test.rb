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

require 'test_helper'

module TavernaPlayer
  class RunsHelperTest < ActionView::TestCase
    setup do
      @run1 = taverna_player_runs(:one)
      @port1 = taverna_player_run_ports(:one)

      @run2 = taverna_player_runs(:three)
      @port2 = taverna_player_run_ports(:four)

      @run3 = taverna_player_runs(:four)
      @port3 = taverna_player_run_ports(:five)
    end

    test "should show text outputs" do
      assert_equal "Hello, World!", @port1.value, "Unexpected workflow output"
      assert show_output(@run1, @port1).include?("<pre>Hello, World!</pre>"),
        "Workflow output not formatted correctly"

      assert_equal "Rob", @port2.value, "Unexpected workflow output"
      assert show_output(@run2, @port2).include?("<pre>Rob</pre>"),
        "Workflow output not formatted correctly"
    end

    test "should autolink text output" do
      assert_equal "(http://example.com/path?query=1)", @port3.value,
        "Unexpected workflow output"
      assert show_output(@run3, @port3).include?("(<a href=\"http://example.com/path?query=1\" target=\"_blank\">http://example.com/path?query=1</a>)"),
        "Workflow output not formatted correctly"
    end
  end
end
