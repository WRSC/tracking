class Attempt < ActiveRecord::Base
	mount_uploader :uploadxml, XmlasUploader
	mount_uploader :uploadjson, JsonasUploader
# Associations
	belongs_to :robot
	belongs_to :mission
	belongs_to :tracker
  has_one    :score
  has_many :coordinates, through: :tracker

# Validations
    validates :name, presence: true, length: { in: 3..40, too_long: "%{count} characters is the maximum allowed", too_short:"%{count} characters is the minimum allowed"  } #,uniqueness: true,
    validates :start, presence: true
    validates :end, presence: true
    validates :mission_id, presence: true
    validates :robot_id, presence: true
		validates :tracker_id, presence: true
end
