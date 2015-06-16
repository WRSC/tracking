class Robot < ActiveRecord::Base
# Associations
belongs_to :team
has_many :attempt		
has_many :mission, through: :attempt				


# Validations
validates :name, presence: true, uniqueness: true, length: { in: 3..20, too_long: "%{count} characters is the maximum allowed", too_short:"%{count} characters is the minimum allowed"  }
validates :category, inclusion: { in: %w(Small Medium Big Motor), message: "%{value} is not a valid category" }, allow_nil: true
end