#------------------------------------------------------------------------------
# Copyright (c) 2013 The University of Manchester, UK.
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
  class ApplicationHelperTest < ActionView::TestCase
    setup do
      @run = taverna_player_runs(:one)
      @workflow = workflows(:one)
    end

    test "should output embedded run path from id" do
      id = 2
      path = new_embedded_run_path(id)
      assert path.include?("embedded=true"), "Path missing 'embedded=true'"
      assert path.include?("workflow_id=#{id}"), "Path missing workflow_id"
      refute path.include?("http://"), "Path should not have a URI scheme"
    end

    test "should output embedded run path from run" do
      id = @run.workflow_id
      path = new_embedded_run_path(@run)
      assert path.include?("embedded=true"), "Path missing 'embedded=true'"
      assert path.include?("workflow_id=#{id}"), "Path missing workflow_id"
      refute path.include?("http://"), "Path should not have a URI scheme"
    end

    test "should output embedded run path from workflow" do
      id = @workflow.id
      path = new_embedded_run_path(@workflow)
      assert path.include?("embedded=true"), "Path missing 'embedded=true'"
      assert path.include?("workflow_id=#{id}"), "Path missing workflow_id"
      refute path.include?("http://"), "Path should not have a URI scheme"
    end

    test "should output embedded run url from id" do
      id = 2
      path = new_embedded_run_url(id)
      assert path.include?("embedded=true"), "Path missing 'embedded=true'"
      assert path.include?("workflow_id=#{id}"), "Path missing workflow_id"
      assert path.include?("http://"), "Path missing a URI scheme"
    end

    test "should output embedded run url from run" do
      id = @run.workflow_id
      path = new_embedded_run_url(@run)
      assert path.include?("embedded=true"), "Path missing 'embedded=true'"
      assert path.include?("workflow_id=#{id}"), "Path missing workflow_id"
      assert path.include?("http://"), "Path missing a URI scheme"
    end

    test "should output embedded run url from workflow" do
      id = @workflow.id
      path = new_embedded_run_url(@workflow)
      assert path.include?("embedded=true"), "Path missing 'embedded=true'"
      assert path.include?("workflow_id=#{id}"), "Path missing workflow_id"
      assert path.include?("http://"), "Path missing a URI scheme"
    end
  end
end
