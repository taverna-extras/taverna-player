require 'test_helper'

module TavernaPlayer
  class RunIoTest < ActiveSupport::TestCase
    test "run port inheritance types" do
      in_port = RunPort::Input.new
      assert_equal("TavernaPlayer::RunPort::Input", in_port.port_type)

      out_port = RunPort::Output.new
      assert_equal("TavernaPlayer::RunPort::Output", out_port.port_type)
    end

    test "should not save run ports without name" do
      in_port = RunPort::Input.new
      assert(!in_port.save, "Saved the run input port without a name")

      out_port = RunPort::Output.new
      assert(!out_port.save, "Saved the run output port without a name")
    end
  end
end
