require 'test_helper'

class CoordinatesControllerTest < ActionController::TestCase
=begin
  setup do
    @coordinate = coordinates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:coordinates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create coordinate" do
    assert_difference('Coordinate.count') do
      post :create, coordinate: { datetime: @coordinate.datetime, latitude: @coordinate.latitude, longitude: @coordinate.longitude, tracker_id: @coordinate.tracker_id }
    end

    assert_redirected_to coordinate_path(assigns(:coordinate))
  end

  test "should show coordinate" do
    get :show, id: @coordinate
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @coordinate
    assert_response :success
  end

  test "should update coordinate" do
    patch :update, id: @coordinate, coordinate: { datetime: @coordinate.datetime, latitude: @coordinate.latitude, longitude: @coordinate.longitude, tracker_id: @coordinate.tracker_id }
    assert_redirected_to coordinate_path(assigns(:coordinate))
  end

  test "should destroy coordinate" do
    assert_difference('Coordinate.count', -1) do
      delete :destroy, id: @coordinate
    end

    assert_redirected_to coordinates_path
  end
=end
end
