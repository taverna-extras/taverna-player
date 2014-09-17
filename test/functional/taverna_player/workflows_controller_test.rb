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
  class WorkflowsControllerTest < ActionController::TestCase
    setup do
      @routes = TavernaPlayer::Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
    end
  end
end
