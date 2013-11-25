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

    test "should not allow both file and value on create input" do
      file = fixture_file_upload "/files/crassostrea_gigas.csv"
      port = RunPort::Input.create(:name => "test_port", :value => "test",
        :file => file)

      assert port.value.blank?, "Value should be blank"
      refute port.file.blank?, "File should be present"
    end

    test "should not allow both file and value on create output" do
      file = fixture_file_upload "/files/crassostrea_gigas.csv"
      port = RunPort::Output.create(:name => "test_port", :value => "test",
        :file => file)

      assert port.value.blank?, "Value should be blank"
      refute port.file.blank?, "File should be present"
    end

    test "should not allow both file and value on update input" do
      file = fixture_file_upload "/files/crassostrea_gigas.csv"
      port = RunPort::Input.create(:name => "test_port")

      port.file = file
      port.value = "test"
      port.save

      assert port.value.blank?, "Value should be blank"
      refute port.file.blank?, "File should be present"
    end

    test "should not allow both file and value on update output" do
      file = fixture_file_upload "/files/crassostrea_gigas.csv"
      port = RunPort::Output.create(:name => "test_port")

      port.file = file
      port.value = "test"
      port.save

      assert port.value.blank?, "Value should be blank"
      refute port.file.blank?, "File should be present"
    end

    test "should change large input value correctly" do
      orig_value =
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"

      new_value =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"\
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"\
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"\
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"\
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"\
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

      port = RunPort::Input.create(:name => "test_port", :value => orig_value)
      refute port.value.blank?, "Value is empty"
      refute port.file.blank?, "File not present"

      port.value = new_value
      port.save
      refute port.value.blank?, "Value is empty"
      refute port.file.blank?, "File not present"
      assert_not_equal orig_value, port.value, "Port still has old value"
    end

    test "should change large output value correctly" do
      orig_value =
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"

      new_value =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"\
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"\
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"\
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"\
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"\
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

      port = RunPort::Output.create(:name => "test_port", :value => orig_value)
      refute port.value.blank?, "Value is empty"
      refute port.file.blank?, "File not present"

      port.value = new_value
      port.save
      refute port.value.blank?, "Value is empty"
      refute port.file.blank?, "File not present"
      assert_not_equal orig_value, port.value, "Port still has old value"
    end

    test "should blank out large value if file changed" do
      orig_value =
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"

      port = RunPort::Input.create(:name => "test_port", :value => orig_value)
      refute port.value.blank?, "Value is empty"
      refute port.file.blank?, "File not present"

      port.file = fixture_file_upload "/files/crassostrea_gigas.csv"
      port.save
      assert_nil port.value, "Port value not nil"
      refute port.file.blank?, "File not present"
    end

    test "should blank out large value if file removed" do
      orig_value =
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"\
        "01234567890123456789012345678901234567890123456789"

      port = RunPort::Input.create(:name => "test_port", :value => orig_value)
      refute port.value.blank?, "Value is empty"
      refute port.file.blank?, "File not present"

      port.file = nil
      port.save
      assert_nil port.value, "Port value not nil"
      assert port.file.blank?, "File not present"
    end
  end
end
