class Score < ActiveRecord::Base
# Associations
	belongs_to :attempt


# Validations
	validates :attempt_id, presence: true, uniqueness: true
	validates :timecost, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
	
end
