json.array!(@members) do |member|
  json.extract! member, :id, :name, :password, :email, :role, :logo, :team_id
  json.url member_url(member, format: :json)
end
