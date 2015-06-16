require 'test_helper'

class MytestControllerTest < ActionController::TestCase
  test "should get mytest" do
    get :mytest
    assert_response :success
  end

end
