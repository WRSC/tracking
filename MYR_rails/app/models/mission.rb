class Mission < ActiveRecord::Base
# Associations
	has_many :attempts
	has_many :markers
	has_many :robots, through: :attempts
	
# Validations
	validates :name, presence: true, uniqueness: true, length: { in: 3..40, too_long: "%{count} characters is the maximum allowed", too_short:"%{count} characters is the minimum allowed"}
	validates :start, presence: true
  	validates :end, presence: true
  	validates :mtype, presence: true
end
