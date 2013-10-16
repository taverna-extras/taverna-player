require 'test_helper'

module TavernaPlayer
  class RunTest < ActiveSupport::TestCase
    test "should not save run with an illegal state" do
      run = Run.new
      run.workflow = workflows(:one)
      run.state = :not_a_state
      assert !run.save, "Saved the run with an illegal state"
    end

    test "should not save run with no workflow" do
      run = Run.new
      run.state = :pending
      assert !run.save, "Saved the run without a workflow id"
    end

    test "should not be able to set state to cancelled" do
      run = Run.new
      run.state = "cancelled"
      refute run.save, "Saved the run with a cancelled state. See the note "\
        "in the run model file for why this is bad."
    end

    test "should cancel run" do
      run = Run.new
      run.workflow = workflows(:one)
      refute run.cancelled?, "Run's stop flag was set upon creation"
      run.cancel
      assert run.cancelled?, "Run was not cancelled"
      assert_equal :cancelled, run.state, "Run's state was not cancelled"
    end

    test "should create run with a default name" do
      run = Run.new
      assert_not_nil run.name, "Default run name is not set."
      assert_not_equal "", run.name, "Default run name is blank ('')."
      assert_equal "None", run.name, "Default run name is not 'None'."
    end

    test "should not save run with nil name" do
      run = Run.new
      run.name = nil
      refute run.save, "Saved the run with a nil name."
    end

    test "should not save run with an empty name" do
      run = Run.new
      run.name = ""
      refute run.save, "Saved the run with an empty name."
    end
  end
end
