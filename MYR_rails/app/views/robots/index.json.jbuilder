json.array!(@robots) do |robot|
  json.extract! robot, :id, :name, :category, :team_id
  json.url robot_url(robot, format: :json)
end
