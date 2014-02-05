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

require 'test_helper'

module TavernaPlayer
  class JobQueueControllerTest < ActionController::TestCase
    setup do
      @routes = TavernaPlayer::Engine.routes
    end

    test "should route to the job queue" do
      assert_routing "/job_queue",
        { :controller => "taverna_player/job_queue",
          :action => "index" }, {}, {}, "Did not route correctly"
    end

    test "should get index" do
      get :index
      assert_response :success, "Response was not success"
      assert_not_nil assigns(:jobs), "Jobs not assigned"
      assert_template "application", "Did not render with the correct layout"
    end

  end
end
