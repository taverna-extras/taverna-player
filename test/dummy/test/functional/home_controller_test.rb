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

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success

    # Check the home page iframe URI is not escaped. Can only test this here
    # because the helpers are not escaped unless called from within a view.
    assert_select "iframe", count: 1
    assert_select "iframe[src=?]", /^(?!.*&amp;).*$/
  end

end
