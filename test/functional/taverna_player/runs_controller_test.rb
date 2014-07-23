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
  class RunsControllerTest < ActionController::TestCase
    setup do
      @run1 = taverna_player_runs(:one)
      @run2 = taverna_player_runs(:two)
      @run3 = taverna_player_runs(:three)
      @run4 = taverna_player_runs(:four)
      @run5 = taverna_player_runs(:five)
      @run8 = taverna_player_runs(:eight)
      @run9 = taverna_player_runs(:nine)
      @int = taverna_player_interactions(:one)
      @workflow1 = workflows(:one)
      @workflow3 = workflows(:three)
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
      assert_routing @run2.outputs[0].path,
        { :controller => "taverna_player/runs", :action => "output",
          :id => "2", :port => "OUT" }, {}, {}, "Did not route correctly"
    end

    test "should route to a deep run output" do
      assert_routing @run2.outputs[0].path(0, 0),
        { :controller => "taverna_player/runs", :action => "output",
          :id => "2", :port => "OUT", :path => "0/0" }, {}, {},
        "Did not route correctly"

      assert_routing @run2.outputs[0].path([1, 2]),
        { :controller => "taverna_player/runs", :action => "output",
          :id => "2", :port => "OUT", :path => "1/2" }, {}, {},
        "Did not route correctly"
    end

    test "should route to a run input" do
      assert_routing @run3.inputs[0].path,
        { :controller => "taverna_player/runs", :action => "input",
          :id => "3", :port => "IN_Value" }, {}, {}, "Did not route correctly"
    end

    test "should route to cancel on a run" do
      assert_routing({ :method => "put", :path => "/runs/1/cancel" },
        { :controller => "taverna_player/runs", :action => "cancel",
          :id => "1" }, {}, {}, "Did not route correctly")
    end

    test "should route to interaction write proxy" do
      assert_routing({ :method => "post",
        :path => "/runs/1/interaction/#{@int.serial}" },
        { :controller => "taverna_player/runs", :action => "write_interaction",
          :id => "1", :serial => @int.serial }, {}, {},
        "Did not route correctly")
    end

    test "should route to interaction read proxy" do
      assert_routing "/runs/1/interaction/#{@int.serial}",
        { :controller => "taverna_player/runs", :action => "read_interaction",
          :id => "1", :serial => @int.serial, }, {}, {},
        "Did not route correctly"
    end

    test "should route to results download" do
      assert_routing "/runs/1/download/results",
        { :controller => "taverna_player/runs", :action => "download_results",
          :id => "1" }, {}, {}, "Did not route correctly"
    end

    test "should route to log download" do
      assert_routing "/runs/1/download/log",
        { :controller => "taverna_player/runs", :action => "download_log",
          :id => "1" }, {}, {}, "Did not route correctly"
    end

    test "should route to input port download" do
      assert_routing "/runs/3/download/input/IN_Value",
        { :controller => "taverna_player/runs", :action => "download_input",
          :id => "3", :port => "IN_Value" }, {}, {}, "Did not route correctly"
    end

    test "should route to output port download" do
      assert_routing "/runs/1/download/output/Message",
        { :controller => "taverna_player/runs", :action => "download_output",
          :id => "1", :port => "Message" }, {}, {}, "Did not route correctly"
    end

    test "should get index and be overridden" do
      get :index, :use_route => :taverna_player
      assert_response :success, "Response was not success"
      assert_not_nil assigns(:runs), "Did not assign a valid runs instance"
      assert_not_nil assigns(:override)
      assert_template "application", "Did not render with the correct layout"
    end

    test "should get new and not be overridden" do
      get :new, :workflow_id => @workflow1, :use_route => :taverna_player
      assert_response :success, "Response was not success"
      refute assigns(:override)
      assert_template "application", "Did not render with the correct layout"
    end

    test "should get new embedded" do
      get :new, :workflow_id => @workflow1, :embedded => "true",
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

    test "should fail to create run via browser" do
      assert_no_difference("Run.count") do
        post :create, :run => { :workflow_id => @workflow1.id, :name => nil }
      end

      assert_equal "Run was not successfully created.", flash[:alert],
        "Incorrect or missing flash notice"
    end

    test "should create run via browser" do
      assert_difference("Run.count") do
        post :create, :run => { :workflow_id => @workflow1.id }
      end

      assert_redirected_to run_path(assigns(:run)),
        "Did not redirect correctly"
      assert_equal "Run was successfully created.", flash[:notice],
        "Incorrect or missing flash notice"
      assert assigns(:run).valid?, "Created run was invalid"
      refute assigns(:run).user_id.nil?, "Run should have a user_id"
    end

    test "should create inputs along with run" do
      assert_difference("Run.count") do
        assert_difference("RunPort.count") do
          post :create, :run => { :workflow_id => @workflow3.id,
                                  :inputs_attributes => [{:value => 'test', :name => 'IN'}]
          }
        end
      end

      assert_redirected_to run_path(assigns(:run)),
        "Did not redirect correctly"
      assert_equal "Run was successfully created.", flash[:notice],
        "Incorrect or missing flash notice"
      assert assigns(:run).valid?, "Created run was invalid"
      refute assigns(:run).user_id.nil?, "Run should have a user_id"

      assert_equal 1, assigns(:run).inputs.size
      assert_equal 'test', assigns(:run).inputs.first.value
    end

    test "should create embedded run via browser" do
      assert_difference("Run.count") do
        post :create,
          :run => { :workflow_id => @workflow1.id, :embedded => "true" }
      end

      assert_redirected_to run_path(assigns(:run)),
        "Did not redirect correctly"
      assert_equal "Run was successfully created.", flash[:notice],
        "Incorrect or missing flash notice"
      assert assigns(:run).valid?, "Created run was invalid"
      assert assigns(:run).embedded?, "Run not marked as embedded"
      assert assigns(:run).user_id.nil?, "Run should not have a user_id"
    end

    test "should create run via json" do
      assert_difference("Run.count") do
        post :create, :run => { :workflow_id => @workflow1.id },
          :format => :json
      end

      assert_response :created, "Response was not created"
      assert_equal "Run was successfully created.", flash[:notice],
        "Incorrect or missing flash notice"
      assert assigns(:run).valid?, "Created run was invalid"
      refute assigns(:run).user_id.nil?, "Run should have a user_id"
    end

    test "should create embedded run via json" do
      assert_difference("Run.count") do
        post :create,
          :run => { :workflow_id => @workflow1.id, :embedded => "true" },
          :format => :json
      end

      assert_response :created, "Response was not created"
      assert_equal "Run was successfully created.", flash[:notice],
        "Incorrect or missing flash notice"
      assert assigns(:run).valid?, "Created run was invalid"
      assert assigns(:run).embedded?, "Run not marked as embedded"
      assert assigns(:run).user_id.nil?, "Run should not have a user_id"
    end

    test "should not destroy running run via browser" do
      @request.env["HTTP_REFERER"] = "/runs"
      assert_no_difference(["Run.count", "RunPort::Output.count"],
        "Run count and output port count changed") do
          delete :destroy, :id => @run1, :use_route => :taverna_player
      end

      assert_equal "Run must be cancelled before deletion.", flash[:alert],
        "Incorrect or missing flash notice"
      assert_response :redirect, "Response was not a redirect"
      assert_redirected_to runs_path, "Did not redirect correctly"
    end

    test "should not destroy running run via json" do
      assert_no_difference(["Run.count", "RunPort::Output.count"],
        "Run count and output port count changed") do
          delete :destroy, :id => @run1, :format => :json
      end

      assert_equal "Run must be cancelled before deletion.", flash[:alert],
        "Incorrect or missing flash notice"
      assert_response :forbidden, "Response was not forbidden"
    end

    test "should not destroy running run with running delayed job" do
      @request.env["HTTP_REFERER"] = "/runs"
      assert_no_difference(["Run.count", "Delayed::Job.count"],
        "Run and Delayed::Job count changed") do
          delete :destroy, :id => @run8, :use_route => :taverna_player
      end

      assert_equal "Run must be cancelled before deletion.", flash[:alert],
        "Incorrect or missing flash notice"
      assert_response :redirect, "Response was not a redirect"
      assert_redirected_to runs_path, "Did not redirect correctly"
    end

    test "should destroy running run with failed delayed job" do
      @request.env["HTTP_REFERER"] = "/runs"
      assert_difference(["Run.count", "Delayed::Job.count"], -1,
        "Run and Delayed::Job count did not reduce") do
          delete :destroy, :id => @run9, :use_route => :taverna_player
      end

      assert_response :redirect, "Response was not a redirect"
      assert_redirected_to runs_path, "Did not redirect correctly"
    end

    test "should cancel run and redirect to index via browser" do
      @request.env["HTTP_REFERER"] = "/runs"
      put :cancel, :id => @run1, :use_route => :taverna_player

      assert_response :redirect, "Response was not a redirect"
      assert_redirected_to runs_path, "Did not redirect correctly"
    end

    test "should cancel run and redirect to show via browser" do
      @request.env["HTTP_REFERER"] = "/runs/1"
      put :cancel, :id => @run1, :use_route => :taverna_player

      assert_response :redirect, "Response was not a redirect"
      assert_redirected_to run_path(@run1), "Did not redirect correctly"
    end

    test "should cancel run via json" do
      put :cancel, :id => @run1, :format => :json

      assert_response :success, "Response was not success"
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

    test "should only return runs from workflow id 1" do
      get :index, :workflow_id => @workflow1
      assert_response :success, "Response was not success"
      assert_not_nil assigns(:runs), "Did not assign a valid runs instance"
      assert_not_nil assigns(:override)
      assert_not_equal Run.count, assigns(:runs).count, "Returned all runs"
      assert_template "application", "Did not render with the correct layout"
    end

    test "should update run name via browser" do
      put :update, :id => @run1, :run => { :name => "New name" }
      assert_not_nil assigns(:run), "Did not assign a valid run instance"
      assert_not_nil assigns(:update_parameters), "Did not filter params"
      assert_equal "New name", assigns(:run).name, "Run name not updated"
      assert_response :redirect, "Response was not a redirect"
      assert_redirected_to run_path(assigns(:run)),
        "Did not redirect correctly"
    end

    test "should only update run name via browser" do
      put :update, :id => @run1,
        :run => { :name => "New name", :run_id => "New id" }
      assert_not_nil assigns(:run), "Did not assign a valid run instance"
      assert_not_nil assigns(:update_parameters), "Did not filter params"
      assert_equal "New name", assigns(:run).name, "Run name not updated"
      assert_not_equal "New id", assigns(:run).run_id, "Run ID updated"
      assert_response :redirect, "Response was not a redirect"
      assert_redirected_to run_path(assigns(:run)),
        "Did not redirect correctly"
    end

    test "should filter update parameters correctly" do
      put :update, :id => @run1, :run => { :run_id => "New id" }
      assert_not_nil assigns(:run), "Did not assign a valid run instance"
      assert_nil assigns(:update_parameters), "Did not filter params"
      assert_not_equal "New id", assigns(:run).run_id, "Run ID updated"
      assert_response :redirect, "Response was not a redirect"
      assert_redirected_to run_path(assigns(:run)),
        "Did not redirect correctly"
    end

    test "should update run name via json" do
      put :update, :id => @run1, :run => { :name => "New name" },
        :format => :json
      assert_not_nil assigns(:run), "Did not assign a valid run instance"
      assert_not_nil assigns(:update_parameters), "Did not filter params"
      assert_equal "New name", assigns(:run).name, "Run name not updated"
      assert_response :success, "Response was not success"
    end

    test "should get run input" do
      get :input, :id => @run3, :port => "IN_Value"
      assert_response :success, "Response was not success"
      assert_not_nil assigns(:run), "Did not assign a valid run instance"
      assert_not_nil assigns(:port), "Did not assign a valid port instance"
      assert_not_nil response.headers["Content-Disposition"],
        "Content-Disposition header not set in response"
      assert_equal response.headers["Content-Disposition"], "inline",
        "Content-Disposition should be set to 'inline'"
      assert_not_nil response.headers["Content-Type"],
        "Content-Type header not set in response"
    end

    test "should download run input" do
      get :download_input, :id => @run3, :port => "IN_Value"
      assert_response :success, "Response was not success"
      assert_not_nil assigns(:run), "Did not assign a valid run instance"
      assert_not_nil assigns(:port), "Did not assign a valid port instance"
      assert_not_nil response.headers["Content-Disposition"],
        "Content-Disposition header not set in response"
      assert response.headers["Content-Disposition"].include?("attachment"),
        "Content-Disposition should be set to 'attachment'"
      assert response.headers["Content-Disposition"].include?("filename="),
        "Content-Disposition should provide a filename"
      assert_not_nil response.headers["Content-Type"],
        "Content-Type header not set in response"
    end

    test "should get run output" do
      get :output, :id => @run1, :port => "Message"
      assert_response :success, "Response was not success"
      assert_not_nil assigns(:run), "Did not assign a valid run instance"
      assert_not_nil assigns(:port), "Did not assign a valid port instance"
      assert_not_nil response.headers["Content-Disposition"],
        "Content-Disposition header not set in response"
      assert_equal response.headers["Content-Disposition"], "inline",
        "Content-Disposition should be set to 'inline'"
      assert_not_nil response.headers["Content-Type"],
        "Content-Type header not set in response"
    end

    test "should download run output" do
      get :download_output, :id => @run1, :port => "Message"
      assert_response :success, "Response was not success"
      assert_not_nil assigns(:run), "Did not assign a valid run instance"
      assert_not_nil assigns(:port), "Did not assign a valid port instance"
      assert_not_nil response.headers["Content-Disposition"],
        "Content-Disposition header not set in response"
      assert response.headers["Content-Disposition"].include?("attachment"),
        "Content-Disposition should be set to 'attachment'"
      assert response.headers["Content-Disposition"].include?("filename="),
        "Content-Disposition should provide a filename"
      assert_not_nil response.headers["Content-Type"],
        "Content-Type header not set in response"
    end
  end
end
