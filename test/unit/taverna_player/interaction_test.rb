require 'test_helper'

module TavernaPlayer
  class InteractionTest < ActiveSupport::TestCase
    test "should not save interaction without a unique_id" do
      int = Interaction.new
      int.serial = "ask0"
      refute int.save, "Saved the interaction without a unique_id"
    end

    test "should not save interaction without a serial number" do
      int = Interaction.new
      int.unique_id = "af19046f-4614-44a7-ad83-f940cea63c4a"
      refute int.save, "Saved the interaction without a serial number"
    end

    test "should not allow two identical serial numbers for the same run" do
      int = Interaction.new
      int.unique_id = "fdb30aed-96ac-4499-b8b6-0a11cf82ccee"
      int.serial = "ask0"
      int.run_id = 4
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
