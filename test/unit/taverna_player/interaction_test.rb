require 'test_helper'

module TavernaPlayer
  class InteractionTest < ActiveSupport::TestCase
    test "should not save interaction without a uri" do
      int = Interaction.new
      refute int.save, "Saved the interaction without a uri"
    end

    test "replied defaults to false" do
      int = Interaction.new
      refute int.replied, "Interaction#replied did not default to false"
    end
  end
end
