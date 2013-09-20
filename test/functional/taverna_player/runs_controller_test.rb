require 'test_helper'

module TavernaPlayer
  class RunsControllerTest < ActionController::TestCase
    setup do
      @run1 = taverna_player_runs(:one)
      @run2 = taverna_player_runs(:two)
      @run3 = taverna_player_runs(:three)
      @run4 = taverna_player_runs(:four)
      @run5 = taverna_player_runs(:five)
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

    test "should route to cancel on a run" do
      assert_routing({ :method => "put", :path => "/runs/1/cancel" },
        { :controller => "taverna_player/runs", :action => "cancel",
          :id => "1" }, {}, {}, "Did not route correctly")
    end

    test "should route to notification feed proxy" do
      assert_routing({ :method => "post", :path => "/runs/1/proxy" },
        { :controller => "taverna_player/runs", :action => "notification",
          :id => "1" }, {}, {}, "Did not route correctly")
    end

    test "should route to interaction resource read proxy" do
      assert_routing "/runs/1/proxy/file.json",
        { :controller => "taverna_player/runs", :action => "read_interaction",
          :id => "1", :name => "file", :format => "json" }, {}, {},
        "Did not route correctly"
    end

    test "should route to interaction resource write proxy" do
      assert_routing({ :method => "put", :path => "/runs/1/proxy/file.json" },
        { :controller => "taverna_player/runs", :action => "save_interaction",
          :id => "1", :name => "file", :format => "json" }, {}, {},
        "Did not route correctly")
    end

    test "should get index and be overridden" do
      get :index, :use_route => :taverna_player
      assert_response :success, "Response was not success"
      assert_not_nil assigns(:runs), "Did not assign a valid runs instance"
      assert_not_nil assigns(:override)
      assert_template "application", "Did not render with the correct layout"
    end

    test "should get new and not be overridden" do
      get :new, :workflow_id => 1, :use_route => :taverna_player
      assert_response :success, "Response was not success"
      refute assigns(:override)
      assert_template "application", "Did not render with the correct layout"
    end

    test "should get new embedded" do
      get :new, :workflow_id => 1, :embedded => "true",
        :use_route => :taverna_player
      assert_response :success, "Response was not success"
      assert_template "taverna_player/embedded",
        "Did not render with the correct layout"
    end

    test "should show run with no interactions" do
      get :show, :id => @run1, :use_route => :taverna_player
      assert_response :success, "Response was not success"
      refute assigns(:interaction), "No interactions for this run"
      assert_template "application", "Did not render with the correct layout"
    end

    test "should show run with an undisplayed interaction" do
      get :show, :id => @run4, :use_route => :taverna_player
      assert_response :success, "Response was not success"
      assert assigns(:interaction), "Should have an interaction for this run"
      assert assigns(:new_interaction), "Should have new interaction flag"
      assert_template "application", "Did not render with the correct layout"
    end

    test "should show run with a displayed interaction" do
      get :show, :id => @run5, :use_route => :taverna_player
      assert_response :success, "Response was not success"
      assert assigns(:interaction), "Should have an interaction for this run"
      refute assigns(:new_interaction), "Should not have new interaction flag"
      assert_template "application", "Did not render with the correct layout"
    end

    test "should show run embedded ignoring replied interaction" do
      get :show, :id => @run3, :use_route => :taverna_player
      assert_response :success, "Response was not success"
      refute assigns(:interaction), "Should not show replied interaction"
      refute assigns(:new_interaction), "Should not have new interaction flag"
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

    test "should not destroy running run" do
      @request.env["HTTP_REFERER"] = "/runs"
      assert_no_difference(["Run.count", "RunPort::Output.count"],
        "Run count and output port count changed") do
          delete :destroy, :id => @run1, :use_route => :taverna_player
      end

      assert_response :redirect, "Response was not a redirect"
      assert_redirected_to runs_path, "Did not redirect correctly"
    end

    test "should cancel run and redirect to index" do
      @request.env["HTTP_REFERER"] = "/runs"
      put :cancel, :id => @run1, :use_route => :taverna_player

      assert_response :redirect, "Response was not a redirect"
      assert_redirected_to runs_path, "Did not redirect correctly"
    end

    test "should cancel run and redirect to show" do
      @request.env["HTTP_REFERER"] = "/runs/2"
      put :cancel, :id => @run2, :use_route => :taverna_player

      assert_response :redirect, "Response was not a redirect"
      assert_redirected_to run_path(@run2), "Did not redirect correctly"
    end

    test "should destroy run and all associated ports and interactions" do
      assert_difference(["Run.count", "RunPort::Input.count",
        "RunPort::Output.count", "Interaction.count"], -1,
        "Counts of objects did not reduce by 1") do
          delete :destroy, :id => @run3, :use_route => :taverna_player
      end

      assert_response :redirect, "Response was not a redirect"
      assert_redirected_to runs_path, "Did not redirect correctly"
    end
  end
end
