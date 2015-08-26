class Robot < ActiveRecord::Base
# Associations
belongs_to :team
has_many :attempts		
has_many :missions, through: :attempts		
has_many :trackers, through: :attempts		


# Validations
validates :name, presence: true,  length: { in: 3..100, too_long: "%{count} characters is the maximum allowed", too_short:"%{count} characters is the minimum allowed"  }#,uniqueness: true
validates :category, inclusion: { in: %w(MicroSailboat Sailboat), message: "%{value} is not a valid category" }, allow_nil: true
validates :team_id, presence: true


end
