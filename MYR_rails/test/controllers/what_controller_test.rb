require 'test_helper'

class WhatControllerTest < ActionController::TestCase
  test "should get what" do
    get :what
    assert_response :success
  end

end
