class Liste < ActiveRecord::Base

# Validations
    validates :latitude, presence: true
    validates :longitude, presence: true
    validates :datetime, presence: true
    validates :tracker_id, presence: true
    validates :token, presence: true

end
