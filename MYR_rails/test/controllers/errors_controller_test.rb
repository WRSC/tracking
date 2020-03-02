require 'test_helper'

class ErrorsControllerTest < ActionController::TestCase
  test "should get file_not_found" do
    get :file_not_found
    assert_response :not_found
  end

  test "should get unprocessable" do
    get :unprocessable
    assert_response 422
  end

  test "should get internal_server_error" do
    get :internal_server_error
    assert_response 500
  end

end
