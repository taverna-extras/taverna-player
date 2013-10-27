require 'test_helper'

module TavernaPlayer
  class TavernaControllerTest < ActionController::TestCase
    setup do
      @routes = TavernaPlayer::Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
    end
  end
end
