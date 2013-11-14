require 'test_helper'

module TavernaPlayer
  class RunIoTest < ActiveSupport::TestCase
    setup do
      @port1 = taverna_player_run_ports(:one)
      @port2 = taverna_player_run_ports(:two)
      @port3 = taverna_player_run_ports(:three)
      @port5 = taverna_player_run_ports(:five)
    end

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

    test "should not save small input values in a file" do
      test_value =
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"

      port = RunPort::Input.create(:name => "test_port")
      port.value = test_value
      assert port.save, "Port did not save"
      assert_equal port.value_preview, port.value, "Value and preview differ"
      assert_nil port.file.path, "File present"
      assert_equal test_value, port.value, "Saved value does not match test"
    end

    test "should not save small output values in a file" do
      test_value =
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"

      port = RunPort::Output.create(:name => "test_port")
      port.value = test_value
      assert port.save, "Port did not save"
      assert_equal port.value_preview, port.value, "Value and preview differ"
      assert_nil port.file.path, "File present"
      assert_equal test_value, port.value, "Saved value does not match test"
    end

    test "should save large input values in a file" do
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
      assert port.read_attribute(:value).size == 255, "Port value size != 255"
      assert_equal test_value, port.value, "Saved value does not match test"
      assert_not_equal port.value_preview, port.value, "Value and preview same"

      port.value = "small"
      assert port.save, "Port did not save"
      assert_nil port.file.path, "File present"
    end

    test "should save large output values in a file" do
      test_value =
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"

      port = RunPort::Output.create(:name => "test_port")
      port.value = test_value
      assert port.save, "Port did not save"
      assert_not_nil port.file.path, "File not present"
      assert port.read_attribute(:value).size == 255, "Port value size != 255"
      assert_equal test_value, port.value, "Saved value does not match test"
      assert_not_equal port.value_preview, port.value, "Value and preview same"

      port.value = "small"
      assert port.save, "Port did not save"
      assert_nil port.file.path, "File present"
    end

    test "should handle non ascii/utf-8 characters in large input values" do
      test_value =
        "\xC2"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "\xC2"

      port = RunPort::Input.create(:name => "test_port")
      port.value = test_value
      assert port.save, "Port did not save"
      assert_not_nil port.file.path, "File not present"
      assert_equal test_value, port.value, "Saved value does not match test"
      assert_not_equal port.value_preview, port.value, "Value and preview same"
    end

    test "should handle non ascii/utf-8 characters in large output values" do
      test_value =
        "\xC2"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "\xC2"

      port = RunPort::Output.create(:name => "test_port")
      port.value = test_value
      assert port.save, "Port did not save"
      assert_not_nil port.file.path, "File not present"
      assert_equal test_value, port.value, "Saved value does not match test"
      assert_not_equal port.value_preview, port.value, "Value and preview same"
    end

    test "should display port names correctly" do
      assert_equal @port1.name, @port1.display_name,
        "Name with no spaces should not be changed"
      assert_equal @port2.name, @port2.display_name,
        "Name with no spaces should not be changed"
      assert_not_equal @port3.name, @port3.display_name,
        "Name with spaces should not be unchanged"
      refute @port3.display_name.include?('_'),
        "Display name should not have any underscores"
      refute @port5.display_name.include?('_'),
        "Display name should not have any underscores"
      assert_equal @port3.name.gsub('_', ' '), @port3.display_name,
        "Only underscores should be changed"
      assert_equal @port5.name.gsub('_', ' '), @port5.display_name,
        "Only underscores should be changed"
    end
  end
end
