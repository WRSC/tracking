class Mission < ActiveRecord::Base
# Associations
	has_many :attempt
	has_many :marker
	has_many :robot, through: :attempt
	
# Validations
	validates :name, presence: true, uniqueness: true, length: { in: 3..40, too_long: "%{count} characters is the maximum allowed", too_short:"%{count} characters is the minimum allowed"}
end