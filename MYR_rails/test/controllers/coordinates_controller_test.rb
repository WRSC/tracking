require 'test_helper'

class CoordinatesControllerTest < ActionController::TestCase
  setup do
    @tracker = trackers(:mytracker)
    @coordinate = coordinates(:c1)
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

  test "creates single coordinate" do
    assert_difference('Coordinate.count', 1) do
      post :create, coordinate: {
        datetime: 20150605010101,
        latitude: "0.5",
        longitude: "1",
        speed: 1,
        course: 1,
        tracker_id: @tracker.id,
        token: @tracker.token
      }, format: :json
    end

    assert_response :created
  end

  test "creates multiple coordinates" do
    assert_difference('Coordinate.count', 2) do
      post :create, coordinate: {
        datetime: "20150605010101_20150606010101",
        latitude: "0.5_0.7",
        longitude: "1_2",
        speed: "1_2",
        course: "1_1",
        tracker_id: @tracker.id,
        token: @tracker.token
      }, format: :json
    end

    assert_response :created
  end


  test "should show coordinate" do
    get :show, id: @coordinate
    assert_response :success
  end

=begin

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
