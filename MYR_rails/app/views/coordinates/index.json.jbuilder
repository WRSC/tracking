json.array!(@coordinates) do |coordinate|
  json.extract! coordinate, :id, :latitude, :longitude, :datetime, :tracker_id
  json.url coordinate_url(coordinate, format: :json)
end
