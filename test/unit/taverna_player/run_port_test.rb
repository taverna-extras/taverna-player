require 'test_helper'

module TavernaPlayer
  class RunIoTest < ActiveSupport::TestCase
    test "run port inheritance types" do
      in_port = RunPort::Input.new
      assert_equal "TavernaPlayer::RunPort::Input", in_port.port_type,
        "Input does not inherit as TavernaPlayer::RunPort::Input"

      out_port = RunPort::Output.new
      assert_equal "TavernaPlayer::RunPort::Output", out_port.port_type,
        "Output does not inherit as TavernaPlayer::RunPort::Output"
    end

    test "should not save run ports without name" do
      in_port = RunPort::Input.new
      assert !in_port.save, "Saved the run input port without a name"

      out_port = RunPort::Output.new
      assert !out_port.save, "Saved the run output port without a name"
    end

    test "should not save small values in a file" do
      test_value =
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"

      port = RunPort::Input.create(:name => "test_port")
      port.value = test_value
      assert port.save, "Port did not save"
      assert_nil port.file.path, "File present"
      assert_equal test_value, port.value, "Saved value does not match test"
    end

    test "should save large values in a file" do
      test_value =
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"

      port = RunPort::Input.create(:name => "test_port")
      port.value = test_value
      assert port.save, "Port did not save"
      assert_not_nil port.file.path, "File not present"
      assert_equal test_value, port.value, "Saved value does not match test"

      port.value = "small"
      assert port.save, "Port did not save"
      assert_nil port.file.path, "File present"
    end
  end
end
