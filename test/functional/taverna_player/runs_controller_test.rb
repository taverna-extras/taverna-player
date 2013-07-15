require 'test_helper'

module TavernaPlayer
  class RunsControllerTest < ActionController::TestCase
    setup do
      @run1 = taverna_player_runs(:one)
      @run2 = taverna_player_runs(:two)
      @run3 = taverna_player_runs(:three)
      @routes = TavernaPlayer::Engine.routes
    end

    test "should route to runs" do
      assert_routing "/runs",
        { :controller => "taverna_player/runs", :action => "index" }, {}, {},
        "Did not route correctly"
    end

    test "should route to a run" do
      assert_routing "/runs/1",
        { :controller => "taverna_player/runs", :action => "show",
          :id => "1" }, {}, {}, "Did not route correctly"
    end

    test "should route to a run output" do
      assert_routing "/runs/1/output/OUT",
        { :controller => "taverna_player/runs", :action => "output",
          :id => "1", :port => "OUT" }, {}, {}, "Did not route correctly"
    end

    test "should route to a deep run output" do
      assert_routing "/runs/1/output/OUT/0/0",
        { :controller => "taverna_player/runs", :action => "output",
          :id => "1", :port => "OUT", :path => "0/0" }, {}, {},
        "Did not route correctly"
    end

    test "should get index" do
      get :index, :use_route => :taverna_player
      assert_response :success, "Response was not success"
      assert_not_nil assigns(:runs), "Did not assign a valid runs instance"
      assert_template "application", "Did not render with the correct layout"
    end

    test "should get new" do
      get :new, :workflow_id => 1, :use_route => :taverna_player
      assert_response :success, "Response was not success"
      assert_template "application", "Did not render with the correct layout"
    end

    test "should get new embedded" do
      get :new, :workflow_id => 1, :embedded => "true",
        :use_route => :taverna_player
      assert_response :success, "Response was not success"
      assert_template "taverna_player/embedded",
        "Did not render with the correct layout"
    end

    test "should show run" do
      get :show, :id => @run1, :use_route => :taverna_player
      assert_response :success, "Response was not success"
      assert_template "application", "Did not render with the correct layout"
    end

    test "should show run embedded" do
      get :show, :id => @run3, :use_route => :taverna_player
      assert_response :success, "Response was not success"
      assert_template "taverna_player/embedded",
        "Did not render with the correct layout"
    end

    test "should create run" do
      assert_difference("Run.count") do
        post :create, :run => { :workflow_id => 1 }
      end

      assert_redirected_to run_path(assigns(:run)),
        "Did not redirect correctly"
      assert_equal 'Run was successfully created.', flash[:notice],
        "Incorrect or missing flash notice"
      assert assigns(:run).valid?, "Created run was invalid"
    end

    test "should destroy run and associated output port" do
      assert_difference(["Run.count", "RunPort::Output.count"], -1) do
        delete :destroy, :id => @run1, :use_route => :taverna_player
      end

      assert_redirected_to runs_path, "Did not redirect correctly"
    end

    test "should destroy run and associated output port and interactions" do
      assert_difference(["Run.count", "RunPort::Output.count",
        "Interaction.count"], -1) do
          delete :destroy, :id => @run2, :use_route => :taverna_player
      end

      assert_redirected_to runs_path, "Did not redirect correctly"
    end

    test "should destroy run and all associated ports and interactions" do
      assert_difference(["Run.count", "RunPort::Input.count",
        "RunPort::Output.count", "Interaction.count"], -1) do
          delete :destroy, :id => @run3, :use_route => :taverna_player
      end

      assert_redirected_to runs_path, "Did not redirect correctly"
    end
  end
end
