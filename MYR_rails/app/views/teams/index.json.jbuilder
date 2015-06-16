json.array!(@teams) do |team|
  json.extract! team, :id, :name, :logo, :description
  json.url team_url(team, format: :json)
end
