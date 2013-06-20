require 'test_helper'

module TavernaPlayer
  class RunsControllerTest < ActionController::TestCase
    setup do
      @run = taverna_player_runs(:one)
      @routes = TavernaPlayer::Engine.routes
    end

    test "should route to runs" do
      assert_routing "/runs",
        { :controller => "taverna_player/runs", :action => "index" }
    end

    test "should route to a run" do
      assert_routing "/runs/1",
        { :controller => "taverna_player/runs", :action => "show", :id => "1" }
    end

    test "should route to a run output" do
      assert_routing "/runs/1/output/OUT",
        { :controller => "taverna_player/runs", :action => "output",
          :id => "1", :port => "OUT" }
    end

    test "should route to a deep run output" do
      assert_routing "/runs/1/output/OUT/0/0",
        { :controller => "taverna_player/runs", :action => "output",
          :id => "1", :port => "OUT", :path => "0/0" }
    end

    test "should get index" do
      get :index, :use_route => :taverna_player
      assert_response :success
      assert_not_nil assigns(:runs)
      assert_template "application"
    end

    test "should get new" do
      get :new, :workflow_id => 1, :use_route => :taverna_player
      assert_response :success
      assert_template "application"
    end

    test "should get new embedded" do
      get :new, :workflow_id => 1, :embedded => 1,
        :use_route => :taverna_player
      assert_response :success
      assert_template "taverna_player/embedded"
    end

    test "should show run" do
      get :show, :id => @run, :use_route => :taverna_player
      assert_response :success
      assert_template "application"
    end

    test "should show run embedded" do
      session[:embedded] = "1"
      get :show, :id => @run, :use_route => :taverna_player
      assert_response :success
      assert_template "taverna_player/embedded"
    end

    test "should create run" do
      assert_difference("Run.count") do
        post :create, :run => { :workflow_id => 1 }
      end

      assert_redirected_to run_path(assigns(:run))
      assert_equal 'Run was successfully created.', flash[:notice]
    end

    test "should destroy run" do
      assert_difference('Run.count', -1) do
        delete :destroy, :id => @run, :use_route => :taverna_player
      end

      assert_redirected_to runs_path
    end
  end
end
