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

    test "should not be able to set state to cancelled if run not stopped" do
      run = Run.new
      run.state = :cancelled
      assert_not_equal :cancelled, run.state, "The run status was set to "\
        "cancelled without being marked as stopped first. See the note in "\
        "the run model file for why this is not allowed."
    end

    test "should not save run with cancelled state if not marked as stopped" do
      run = Run.new
      run.workflow = workflows(:one)
      run.saved_state = "cancelled"
      run.stop = false
      refute run.save, "Saved run with cancelled state when not stopped first"
    end

    test "should cancel run if run set to stop first" do
      run = Run.new
      run.workflow = workflows(:one)
      refute run.stop, "Run's stop flag was set upon creation"
      run.cancel
      run.state = :cancelled
      assert run.cancelled?, "Run was not cancelled"
      assert run.complete?, "Run not showing as complete when cancelled"
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

    test "complete run states" do
      refute taverna_player_runs(:one).complete?, "Run not complete"
      refute taverna_player_runs(:two).complete?, "Run not complete"
      assert taverna_player_runs(:three).complete?, "Run is complete"
      refute taverna_player_runs(:four).complete?, "Run not complete"
      refute taverna_player_runs(:five).complete?, "Run not complete"
      assert taverna_player_runs(:six).complete?, "Run is complete"
    end

    test "a parent cannot be younger than its child" do
      older = Run.create(:workflow_id => 1)
      young = Run.create(:workflow_id => 1)
      older.parent = young
      refute older.save, "Run saved with a younger parent"
    end

    test "parent/child graph should be acyclic" do
      parent = Run.create(:workflow_id => 1)
      child = Run.create(:workflow_id => 1)
      parent.children << child
      parent.parent = child
      refute parent.save, "Run saved with child as its parent"
    end

    test "finding root ancestor of a run" do
      one = Run.create(:workflow_id => 1)
      assert_same one, one.root_ancestor, "Single run is not its own root"
      assert_equal 0, one.children.count, "Not a parent, should not have children"

      two = Run.create(:workflow_id => 1)
      assert_same two, two.root_ancestor, "Single run is not its own root"

      two.parent = one
      two.save
      assert_same one, one.root_ancestor, "Parent run is not its own root"
      assert_same one, two.root_ancestor, "Child run does not have parent as its root"
      assert_equal 1, one.children.count, "Parent should have one child"

      three = Run.create(:workflow_id => 1)
      assert_same three, three.root_ancestor, "Single run is not its own root"

      three.parent = two
      three.save
      assert_same one, one.root_ancestor, "Parent run is not its own root"
      assert_same one, two.root_ancestor, "Child run does not have parent as its root"
      assert_same one, three.root_ancestor, "Grandchild run does not have grandparent as its root"
      assert_equal 1, two.children.count, "Parent should have one child"
      assert_equal 1, one.children.count, "Grandparent should have one child"

      four = Run.create(:workflow_id => 1)
      assert_same four, four.root_ancestor, "Single run is not its own root"

      four.parent = one
      four.save
      assert_same one, four.root_ancestor, "Child run does not have parent as its root"
      assert_equal 2, one.children.count, "Parent should have two children"
    end

    test "should create run from another run" do
      assert_difference(["Run.count", "RunPort::Input.count"]) do
        parent = taverna_player_runs(:three)
        run = Run.create_from_run(parent)
        assert run.valid?, "Run is invalid"
        refute run.new_record?, "Run was not saved"
        assert_equal 1, run.inputs.count, "Run should have 1 input"
        refute_same parent.inputs.first, run.inputs.first, "Input was linked, not copied"
      end
    end

    test "new run from another run" do
      assert_difference(["Run.count", "RunPort::Input.count"]) do
        parent = taverna_player_runs(:three)
        run = Run.new_from_run(parent)
        assert run.save, "Run was not saved"
        assert_equal 1, run.inputs.count, "Run should have 1 input"
        refute_same parent.inputs.first, run.inputs.first, "Input was linked, not copied"
      end
    end
  end
end
