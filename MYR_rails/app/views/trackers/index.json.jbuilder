json.array!(@trackers) do |tracker|
  json.extract! tracker, :id, :token, :description, :enabled
  json.url tracker_url(tracker, format: :json)
end
