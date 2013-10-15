require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success

    # Check the home page iframe URI is not escaped. Can only test this here
    # because the helpers are not escaped unless called from within a view.
    assert_select "iframe" do
      assert_select "[src=?]", /^(?!.*&amp;).*$/, "",
        "iframe URI contains &amp;"
    end
  end

end
