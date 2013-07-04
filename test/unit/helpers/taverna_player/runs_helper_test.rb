require 'test_helper'

module TavernaPlayer
  class RunsHelperTest < ActionView::TestCase
    setup do
      @run1 = taverna_player_runs(:one)
      @port1 = taverna_player_run_ports(:one)

      @run2 = taverna_player_runs(:three)
      @port2 = taverna_player_run_ports(:four)
    end

    test "should show text outputs" do
      assert_equal "Hello, World!", @port1.value, "Unexpected workflow output"
      assert show_output(@run1, @port1).include?("<pre>Hello, World!</pre>"),
        "Workflow output not formatted correctly"

      assert_equal "Rob", @port2.value, "Unexpected workflow output"
      assert show_output(@run2, @port2).include?("<pre>Rob</pre>"),
        "Workflow output not formatted correctly"
    end
  end
end
