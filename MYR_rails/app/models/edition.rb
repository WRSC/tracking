class Edition < ActiveRecord::Base
	# Associations
	has_many :missions
	
	# Validations
end