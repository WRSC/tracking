class Coordinate < ActiveRecord::Base
# Associations
	belongs_to :tracker

# Validations
    validates :latitude, presence: true
    validates :longitude, presence: true
    validates :datetime, presence: true
    validates :tracker_id, presence: true

	def self.to_csv(options = {})
	  	CSV.generate(options) do |csv|
		    all.select("datetime, latitude, longitude").each do |coordinate|
			    date = Time.strptime(coordinate.attributes['datetime'],'%Y%m%d%H%M%S').strftime("%H%M%S%d")
			    latitude = ((coordinate.attributes['latitude']).to_f*(10**7)).to_i
			    longitude = ((coordinate.attributes['longitude']).to_f*(10**7)).to_i
			    values =  [date,latitude,longitude]
			    csv.add_row values
		    end
	  	end
	end

end

