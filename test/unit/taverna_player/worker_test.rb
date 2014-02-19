#------------------------------------------------------------------------------
# Copyright (c) 2014 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Taverna Player was developed in the BioVeL project, funded by the European
# Commission 7th Framework Programme (FP7), through grant agreement
# number 283359.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

require 'flexmock'
require 'test_helper'

class WorkerTest < ActiveSupport::TestCase
  include FlexMock::TestCase

  setup do
    @noop_callback = Proc.new { }

    # Taverna Server config that we need to set here for Travis, etc.
    TavernaPlayer.setup do |config|
      config.server_address = "http://localhost:1111/taverna"
      config.server_username = "taverna"
      config.server_password = "taverna"
      config.server_poll_interval = 0
      config.server_retry_interval = 0
      config.pre_run_callback = @noop_callback
      config.post_run_callback = @noop_callback
      config.run_cancelled_callback = @noop_callback
      config.run_failed_callback = @noop_callback
    end

    # Stuff we can't test yet in TavernaPlayer::Worker.
    flexmock(TavernaPlayer::Worker).new_instances do |w|
      w.should_receive(:download_outputs).and_return_undefined
      w.should_receive(:download_log).and_return_undefined
      w.should_receive(:process_outputs).and_return([])
    end

    @run = taverna_player_runs(:seven)
    @worker = TavernaPlayer::Worker.new(@run)
  end

  test "max attempts should be 1" do
    assert_equal 1, @worker.max_attempts, "Max attempts was not 1."
  end

  test "run a workflow" do
    # Stub the creation of a run on a Taverna Server with a failure first.
    flexmock(T2Server::Server).new_instances do |s|
      s.should_receive(:initialize_run).twice.
        and_raise(T2Server::ServerAtCapacityError).
        and_return(URI.parse("http://localhost/run/01"))
    end

    # Stub the Taverna Server run calls.
    flexmock(T2Server::Run).new_instances do |r|
      r.should_receive(:status).times(4).and_return(:initialized, :running, :running, :finished)
      r.should_receive(:create_time).and_return(Time.now)
      r.should_receive(:add_password_credential).and_return(true)
      r.should_receive(:name=).once.and_return(true)
      r.should_receive(:start).twice.and_return(false, true)
      r.should_receive(:start_time).and_return(Time.now)
      r.should_receive(:notifications).and_return([])
      r.should_receive(:finish_time).and_return(Time.now)
      r.should_receive(:delete).and_return_undefined
    end

    assert_equal :pending, @run.state, "Initial run state not ':pending'"
    assert_nil @run.run_id, "Server run ID not nil before creation"
    assert_nil @run.create_time, "Create time not nil before creation"
    assert_nil @run.start_time, "Start time not nil before starting"
    assert_nil @run.finish_time, "Finish time not nil before run"

    @worker.perform

    assert_equal :finished, @run.state, "Final run state not ':finished'"
    assert_equal "01", @run.run_id, "Server run ID not set correctly"
    assert_not_nil @run.create_time, "Create time nil after creation"
    assert_not_nil @run.start_time, "Start time nil after starting"
    assert_not_nil @run.finish_time, "Finish time nil after finishing"
  end

  test "workflow failure" do
    # Stub the creation of a run on a Taverna Server.
    flexmock(T2Server::Server).new_instances do |s|
      s.should_receive(:initialize_run).
        and_return(URI.parse("http://localhost/run/01"))
    end

    # Stub a Taverna Server run calls so it fails.
    flexmock(T2Server::Run).new_instances do |r|
      r.should_receive(:status).and_raise(RuntimeError)
    end

    assert_equal :pending, @run.state, "Initial run state not ':pending'"

    @worker.perform

    assert_equal :failed, @run.state, "Final run state not ':failed'"
  end

  test "fail in failure handler" do
    # Stub the creation of a run on a Taverna Server with complete failure.
    flexmock(T2Server::Server).new_instances do |s|
      s.should_receive(:initialize_run).once.
        and_raise(RuntimeError)
    end

    # Set a failing failure callback
    TavernaPlayer.run_failed_callback = Proc.new { raise RuntimeError }

    assert_equal :pending, @run.state, "Initial run state not ':pending'"

    @worker.perform

    assert_equal :failed, @run.state, "Final run state not ':failed'"
    assert_not_nil @run.failure_message, "Run's failure message is nil"
  end

  test "cancelled run" do
    # Stub the creation of a run on a Taverna Server with a failure.
    flexmock(T2Server::Server).new_instances do |s|
      s.should_receive(:initialize_run).once.
        and_raise(T2Server::ServerAtCapacityError)
    end

    # Cancel the run.
    @run.stop = true
    @run.save

    assert_equal :pending, @run.state, "Initial run state not ':pending'"

    @worker.perform

    assert_equal :cancelled, @run.state, "Final run state not ':cancelled'"
  end

  test "fail in cancelled callback" do
    # Stub the creation of a run on a Taverna Server with a failure.
    flexmock(T2Server::Server).new_instances do |s|
      s.should_receive(:initialize_run).once.
        and_raise(T2Server::ServerAtCapacityError)
    end

    # Set a failing cancelled callback
    TavernaPlayer.run_cancelled_callback = Proc.new { raise RuntimeError }

    # Cancel the run.
    @run.stop = true
    @run.save

    assert_equal :pending, @run.state, "Initial run state not ':pending'"

    @worker.perform

    assert_equal :failed, @run.state, "Final run state not ':failed'"
    assert_not_nil @run.failure_message, "Run's failure message is nil"
  end
end
