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

  SERVER_ADDRESS = "http://localhost:1111/taverna"

  setup do
    @noop_callback = Proc.new { }

    # Taverna Server config that we need to set here for Travis, etc.
    TavernaPlayer.setup do |config|
      config.server_address = SERVER_ADDRESS
      config.server_username = "taverna"
      config.server_password = "taverna"
      config.server_poll_interval = 0
      config.server_retry_interval = 0
      config.pre_run_callback = @noop_callback
      config.post_run_callback = @noop_callback
      config.run_cancelled_callback = @noop_callback
      config.run_failed_callback = @noop_callback
      config.current_user_callback =
        Proc.new { User.find(ActiveRecord::Fixtures.identify(:test_user)) }
    end

    # Stuff we can't test yet in TavernaPlayer::Worker.
    flexmock(TavernaPlayer::Worker).new_instances do |w|
      w.should_receive(:download_outputs).and_return_undefined
      w.should_receive(:process_outputs).and_return([])
    end

    @run = taverna_player_runs(:seven)
    @worker = TavernaPlayer::Worker.new(@run)
  end

  test "max attempts should be 1" do
    assert_equal 1, @worker.max_attempts, "Max attempts was not 1."
  end

  test "server address not set to a uri initially" do
    assert_raise(URI::InvalidURIError) do
      URI.parse(@worker.server)
    end
  end

  test "server address and creds from config" do
    # Stub the creation of a run on a Taverna Server so it fails.
    flexmock(T2Server::Server).new_instances do |s|
      s.should_receive(:initialize_run).once.
        and_raise(RuntimeError)
    end

    @worker.perform

    assert_equal SERVER_ADDRESS, @worker.server.to_s,
      "Server address not read from config."
  end

  test "server address and creds from env" do
    ENV["TAVERNA_URI"] = "https://localhost:8080/taverna"
    ENV["TAVERNA_CREDENTIALS"] = "taverna:taverna"

    # Stub the creation of a run on a Taverna Server so it fails.
    flexmock(T2Server::Server).new_instances do |s|
      s.should_receive(:initialize_run).once.
        and_raise(RuntimeError)
    end

    @worker.perform

    assert_equal ENV["TAVERNA_URI"], @worker.server.to_s,
      "Server address not read from env."
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
      r.should_receive(:log).once.and_return(0)
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
    assert_not_nil @run.failure_message, "Run's failure message is nil"
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

  test "immediately cancelled run" do
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

  test "run cancelled while waiting to start" do
    # Stub the creation of a run on a Taverna Server.
    flexmock(T2Server::Server).new_instances do |s|
      s.should_receive(:initialize_run).once.
        and_return(URI.parse("http://localhost/run/02"))
    end

    # Stub the Taverna Server run calls.
    flexmock(T2Server::Run).new_instances do |r|
      r.should_receive(:status).and_return(:initialized)
      r.should_receive(:create_time).and_return(Time.now)
      r.should_receive(:add_password_credential).and_return(true)
      r.should_receive(:name=).once.and_return(true)
      r.should_receive(:start).and_return(false)
      r.should_receive(:log).once.and_return(0)
      r.should_receive(:delete).and_return_undefined
    end

    # Stub the TavernaPlayer::Worker.cancelled? method and set the internal
    # run model state stop to true.
    worker = TavernaPlayer::Worker.new(@run)
    flexmock(worker).should_receive(:cancelled?).once.and_return(true)
    @run.stop = true
    @run.save

    assert_equal :pending, @run.state, "Initial run state not ':pending'"

    worker.perform

    assert_equal :cancelled, @run.state, "Final run state not ':cancelled'"
  end

  test "run cancelled while running" do
    # Stub the creation of a run on a Taverna Server.
    flexmock(T2Server::Server).new_instances do |s|
      s.should_receive(:initialize_run).once.
        and_return(URI.parse("http://localhost/run/03"))
    end

    # Stub the Taverna Server run calls.
    flexmock(T2Server::Run).new_instances do |r|
      r.should_receive(:status).times(3).and_return(:initialized, :running, :running)
      r.should_receive(:create_time).and_return(Time.now)
      r.should_receive(:add_password_credential).and_return(true)
      r.should_receive(:name=).once.and_return(true)
      r.should_receive(:start).and_return(true)
      r.should_receive(:start_time).and_return(Time.now)
      r.should_receive(:log).once.and_return(0)
      r.should_receive(:delete).and_return_undefined
    end

    # Stub the TavernaPlayer::Worker.cancelled? method and set the internal
    # run model state stop to true.
    worker = TavernaPlayer::Worker.new(@run)
    flexmock(worker).should_receive(:cancelled?).once.and_return(true)
    @run.stop = true
    @run.save

    assert_equal :pending, @run.state, "Initial run state not ':pending'"

    worker.perform

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

  test "fail in pre run callback" do
    # Set a failing pre_run callback
    TavernaPlayer.pre_run_callback = Proc.new { raise RuntimeError }

    assert_equal :pending, @run.state, "Initial run state not ':pending'"

    @worker.perform

    assert_equal :failed, @run.state, "Final run state not ':failed'"
    assert_not_nil @run.failure_message, "Run's failure message is nil"
  end

  test "fail in post run callback" do
    # Set a failing post_run callback
    TavernaPlayer.post_run_callback = Proc.new { raise RuntimeError }

    # Stub the creation of a run on a Taverna Server.
    flexmock(T2Server::Server).new_instances do |s|
      s.should_receive(:initialize_run).once.
        and_return(URI.parse("http://localhost/run/01"))
    end

    # Stub the Taverna Server run calls.
    flexmock(T2Server::Run).new_instances do |r|
      r.should_receive(:status).times(3).and_return(:initialized, :running, :finished)
      r.should_receive(:create_time).and_return(Time.now)
      r.should_receive(:add_password_credential).and_return(true)
      r.should_receive(:name=).once.and_return(true)
      r.should_receive(:start).once.and_return(true)
      r.should_receive(:start_time).and_return(Time.now)
      r.should_receive(:notifications).and_return([])
      r.should_receive(:finish_time).and_return(Time.now)
      r.should_receive(:log).once.and_return(0)
      r.should_receive(:delete).and_return_undefined
    end

    assert_equal :pending, @run.state, "Initial run state not ':pending'"

    @worker.perform

    assert_equal :failed, @run.state, "Final run state not ':failed'"
    assert_not_nil @run.failure_message, "Run's failure message is nil"
  end

  test "timed out run" do
    # Stub the creation of a run on a Taverna Server with a timeout.
    flexmock(T2Server::Server).new_instances do |s|
      s.should_receive(:initialize_run).once.
        and_raise(Delayed::WorkerTimeout)
    end

    assert_equal :pending, @run.state, "Initial run state not ':pending'"

    @worker.perform

    assert_equal :timeout, @run.state, "Final run state not ':timeout'"
  end

  test "network error with recovery" do
    # Stub the creation of a run on a Taverna Server with a network error
    # first.
    flexmock(T2Server::Server).new_instances do |s|
      s.should_receive(:initialize_run).twice.
        and_raise(T2Server::ConnectionError, Timeout::Error.new).
        and_return(URI.parse("http://localhost/run/01"))
    end

    # Stub the Taverna Server run calls.
    flexmock(T2Server::Run).new_instances do |r|
      r.should_receive(:status).times(3).and_return(:initialized, :running, :finished)
      r.should_receive(:create_time).and_return(Time.now)
      r.should_receive(:add_password_credential).and_return(true)
      r.should_receive(:name=).once.and_return(true)
      r.should_receive(:start).once.and_return(true)
      r.should_receive(:start_time).and_return(Time.now)
      r.should_receive(:notifications).and_return([])
      r.should_receive(:finish_time).and_return(Time.now)
      r.should_receive(:log).once.and_return(0)
      r.should_receive(:delete).and_return_undefined
    end

    assert_equal :pending, @run.state, "Initial run state not ':pending'"

    @worker.perform

    assert_equal :finished, @run.state, "Final run state not ':finished'"
  end

end
