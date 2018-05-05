require 'test_helper'

class CoordinatesControllerTest < ActionController::TestCase
  setup do
    @tracker = trackers(:testotron_tracker)
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

  def create_coordinate(tracker, datetime)
    Coordinate.create!(
      tracker: tracker,
      datetime: datetime.strftime("%Y%m%d%H%M%S"),
      longitude: 1,
      latitude: 2,
      speed: 1,
    )
  end

  test "#latest_by_mission without ?limit" do
    mission = missions(:triangularRace)
    datetime = 5.minutes.from_now

    mission.attempts.each do |attempt|
      create_coordinate(attempt.tracker, datetime)
    end

    get :latest_by_mission, id: mission.id
    assert_response :success

    parsed_response = JSON.parse(response.body)
    assert_equal 2, parsed_response.size

    tracker_keys = %w(tracker_id robot_id robot_name team_name latest_coordinates)
    assert_equal tracker_keys, parsed_response.first.keys

    coordinate_keys = %w(latitude longitude datetime)
    assert_equal coordinate_keys, parsed_response.first["latest_coordinates"][0].keys

    assert_equal [datetime.iso8601, datetime.iso8601], parsed_response.map { |c| c.dig("latest_coordinates", 0, "datetime") }
  end

  test "#latest_by_mission with ?limit=5" do
    mission = missions(:triangularRace)
    datetime = 5.minutes.from_now

    mission.attempts.each do |attempt|
      6.times { create_coordinate(attempt.tracker, datetime) }
    end

    get :latest_by_mission, id: mission.id, limit: 5
    assert_response :success

    parsed_response = JSON.parse(response.body)
    assert_equal 2, parsed_response.size

    assert_equal 5, parsed_response[0]["latest_coordinates"].size
    assert_equal 5, parsed_response[1]["latest_coordinates"].size
  end

  test "#latest_by_mission with ?limit=501" do
    mission = missions(:triangularRace)

    get :latest_by_mission, id: mission.id, limit: 501
    assert_response :bad_request
  end

  test "#latest_by_mission with ?limit=0" do
    mission = missions(:triangularRace)

    get :latest_by_mission, id: mission.id, limit: 501
    assert_response :bad_request
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
