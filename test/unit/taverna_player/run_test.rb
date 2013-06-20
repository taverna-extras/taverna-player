require 'test_helper'

module TavernaPlayer
  class RunTest < ActiveSupport::TestCase
    test "should not save run with an illegal state" do
      run = Run.new
      run.workflow_id = 1
      run.state = :not_a_state
      assert(!run.save, "Saved the run with an illegal state")
    end

    test "should not save run with no workflow" do
      run = Run.new
      run.state = :pending
      assert(!run.save, "Saved the run without a workflow id")
    end
  end
end
