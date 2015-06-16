json.array!(@attempts) do |attempt|
  json.extract! attempt, :id, :name, :start, :end, :robot_id, :mission_id, :tracker_id
  json.url attempt_url(attempt, format: :json)
end
