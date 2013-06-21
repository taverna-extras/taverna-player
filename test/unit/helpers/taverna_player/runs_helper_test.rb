require 'test_helper'

module TavernaPlayer
  class RunsHelperTest < ActionView::TestCase
    setup do
      @port1 = taverna_player_run_ports(:one)
      @port2 = taverna_player_run_ports(:four)
    end

    test "should show text outputs" do
      assert_equal "Hello, World!", @port1.value, "Unexpected workflow output"
      assert_equal "<p>Hello, World!</p>", show_output(@port1),
        "Workflow output not formatted correctly"

      assert_equal "Rob", @port2.value, "Unexpected workflow output"
      assert_equal "<p>Rob</p>", show_output(@port2),
        "Workflow output not formatted correctly"
    end
  end
end
