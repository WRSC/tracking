json.array!(@markers) do |marker|
  json.extract! marker, :id, :name, :description, :latitude, :longitude, :datetime, :mission_id
  json.url marker_url(marker, format: :json)
end
