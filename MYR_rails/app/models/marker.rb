class Marker < ActiveRecord::Base
# Associations
	belongs_to :mission


# Validations
	#validates :name, length: { in: 3..40, too_long: "%{count} characters is the maximum allowed", too_short:"%{count} characters is the minimum allowed"  }

	#validates :description, allow_blank: true

	#validates :latitude, presence: true

	#validates :longitude, presence: true

	#validates :datetime, presence: true

end

