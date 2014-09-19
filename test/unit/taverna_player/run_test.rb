#------------------------------------------------------------------------------
# Copyright (c) 2013, 2014 The University of Manchester, UK.
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
  class RunTest < ActiveSupport::TestCase

    setup do
      @run1 = taverna_player_runs(:one)
      @run2 = taverna_player_runs(:two)
      @run3 = taverna_player_runs(:three)
      @run4 = taverna_player_runs(:four)
      @run5 = taverna_player_runs(:five)
      @run6 = taverna_player_runs(:six)
      @run8 = taverna_player_runs(:eight)
      @run9 = taverna_player_runs(:nine)
      @run10 = taverna_player_runs(:ten)
      @run11 = taverna_player_runs(:eleven)
      @workflow = taverna_player_workflows(:one)
    end

    test "should not save run with an illegal state" do
      run = Run.new
      run.workflow = @workflow
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
      run.workflow = @workflow
      run.saved_state = "cancelled"
      run.stop = false
      refute run.save, "Saved run with cancelled state when not stopped first"
    end

    test "should cancel run if run set to stop first" do
      run = Run.new
      run.workflow = @workflow
      refute run.stop, "Run's stop flag was set upon creation"
      run.cancel
      run.state = :cancelled
      assert run.cancelled?, "Run was not cancelled"
      assert run.complete?, "Run not showing as complete when cancelled"
      assert_equal :cancelled, run.state, "Run's state was not cancelled"
    end

    test "should not be able to set state to cancelling directly" do
      run = Run.new
      run.workflow = @workflow
      assert run.save, "Could not save run initially"

      run.state = :cancelling
      refute run.save, "Saved the run with the cancelling state."
    end

    test "should be in cancelling state after being cancelled" do
      run = Run.new
      run.workflow = @workflow
      run.state = :running
      assert run.save, "Could not save run initially."
      run.delayed_job_id = nil # Remove delayed job to pretend it is running.
      assert_equal :running, run.state, "Run is not in running state."

      run.cancel
      assert run.stop, "Run was not stopped."
      assert run.cancelling?, "Run did not move into cancelling state"
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
      refute @run1.complete?, "Run not complete"
      refute @run2.complete?, "Run not complete"
      assert @run3.complete?, "Run is complete"
      refute @run4.complete?, "Run not complete"
      refute @run5.complete?, "Run not complete"
      assert @run6.complete?, "Run is complete"
      refute @run8.complete?, "Run not complete"
      assert @run9.complete?, "Run is complete"
      assert @run10.complete?, "Run is complete"
      refute @run11.complete?, "Run not complete"
    end

    test "a parent cannot be younger than its child" do
      older = Run.create(:workflow_id => @workflow.id)
      young = Run.create(:workflow_id => @workflow.id)
      older.parent = young
      refute older.save, "Run saved with a younger parent"
    end

    test "parent/child graph should be acyclic" do
      parent = Run.create(:workflow_id => @workflow.id)
      child = Run.create(:workflow_id => @workflow.id)
      parent.children << child
      parent.parent = child
      refute parent.save, "Run saved with child as its parent"
    end

    test "finding root ancestor of a run" do
      one = Run.create(:workflow_id => @workflow.id)
      assert_same one, one.root_ancestor, "Single run is not its own root"
      assert_equal 0, one.children.count, "Not a parent, should not have children"

      two = Run.create(:workflow_id => @workflow.id)
      assert_same two, two.root_ancestor, "Single run is not its own root"

      two.parent = one
      two.save
      assert_same one, one.root_ancestor, "Parent run is not its own root"
      assert_same one, two.root_ancestor, "Child run does not have parent as its root"
      assert_equal 1, one.children.count, "Parent should have one child"

      three = Run.create(:workflow_id => @workflow.id)
      assert_same three, three.root_ancestor, "Single run is not its own root"

      three.parent = two
      three.save
      assert_same one, one.root_ancestor, "Parent run is not its own root"
      assert_same one, two.root_ancestor, "Child run does not have parent as its root"
      assert_same one, three.root_ancestor, "Grandchild run does not have grandparent as its root"
      assert_equal 1, two.children.count, "Parent should have one child"
      assert_equal 1, one.children.count, "Grandparent should have one child"

      four = Run.create(:workflow_id => @workflow.id)
      assert_same four, four.root_ancestor, "Single run is not its own root"

      four.parent = one
      four.save
      assert_same one, four.root_ancestor, "Child run does not have parent as its root"
      assert_equal 2, one.children.count, "Parent should have two children"
    end

    test "create run from another run" do
      assert_difference(["Run.count", "RunPort::Input.count"]) do
        parent = @run3
        run = Run.create(:parent_id => parent.id)
        assert run.valid?, "Run is invalid"
        refute run.new_record?, "Run was not saved"
        assert run.has_parent?, "Run should have a parent"
        assert_equal 1, run.inputs.count, "Run should have 1 input"
        refute_same parent.inputs.first, run.inputs.first, "Input was linked, not copied"
      end
    end

    test "new run from another run" do
      assert_difference(["Run.count", "RunPort::Input.count"]) do
        parent = @run3
        run = Run.new(:parent_id => parent.id)
        assert run.save, "Run was not saved"
        assert run.has_parent?, "Run should have a parent"
        assert_equal 1, run.inputs.count, "Run should have 1 input"
        refute_same parent.inputs.first, run.inputs.first, "Input was linked, not copied"
      end
    end

    test "killing parent should orphan child" do
      parent = @run3
      run = Run.create(:parent_id => parent.id)
      assert run.valid?, "Child run is invalid"
      assert_not_nil run.parent_id, "Child run has no parent"

      parent.state = :finished # Fake it.
      parent.save
      assert_difference(["Run.count", "RunPort::Input.count"], -1) do
        parent.destroy
      end

      # Reload child state
      run.reload
      assert_nil run.parent_id, "Child run still has a parent"
    end

    test "delayed job state affects run state" do
      assert @run8.initialized?, "Run should be initialized"
      assert @run9.pending?, "Run should be pending"

      assert @run10.running?, "Run should be running"
      assert @run11.running?, "Run should be running"

      refute @run8.job_failed?, "Job has not failed"
      assert @run9.job_failed?, "Job has failed"
      assert @run10.job_failed?, "Job has failed"
      refute @run11.job_failed?, "Job has not failed"
    end

    test "can delete running run with failed delayed job" do
      assert_difference(["Run.count", "Delayed::Job.count"], -1) do
        @run9.destroy
      end
    end

    test "cannot delete running run with running delayed job" do
      assert_no_difference(["Run.count", "Delayed::Job.count"]) do
        @run8.destroy
      end
    end

    test "cancelling run where delayed job not locked" do
      assert_no_difference("Run.count") do
        assert_difference("Delayed::Job.count", -1) do
          @run8.cancel
        end
      end

      assert @run8.cancelled?, "Run should be cancelled"
    end

    test "cancelling run where delayed job has failed" do
      assert_no_difference("Run.count") do
        assert_difference("Delayed::Job.count", -1) do
          @run9.cancel
        end
      end

      assert @run9.cancelled?, "Run should be cancelled"

      assert_no_difference("Run.count") do
        assert_difference("Delayed::Job.count", -1) do
          @run10.cancel
        end
      end

      assert @run10.cancelled?, "Run should be cancelled"
    end

    test "do not destroy running delayed job upon cancel" do
      assert_no_difference(["Run.count", "Delayed::Job.count"]) do
        @run11.cancel
      end

      assert @run11.cancelling?, "Run should be cancelling"
    end
  end
end
