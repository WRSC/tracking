class Score < ActiveRecord::Base
# Associations
	belongs_to :attempt


# Validations
		validates :attempt_id, presence: true
end
