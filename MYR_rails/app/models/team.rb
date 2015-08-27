class Team < ActiveRecord::Base
  attr_accessor :logo, :remote_logo_url
  mount_uploader :logo, TeamlogoUploader
# Associations
	has_many :members		
	has_many :robots		


# Validations
    validates :name, presence: true, uniqueness: true, length: { in: 3..40, too_long: "%{count} characters is the maximum allowed", too_short:"%{count} characters is the minimum allowed"  }
    validates :logo, allow_blank: true, format: {with: %r{\.(gif|jpg|jpeg|png)\Z}i, message: 'must be GIF, JPG or PNG image'}	
  #  validate :valid_size
=begin
    def valid_size
        if self.logo != ""
            if FastImage.size(self.logo)!= nil
                if FastImage.size(self.logo)[0] > 100
                    errors.add(:logo, "width must be under 100 pixels")
                end
                if FastImage.size(self.logo)[1] > 100
                    errors.add(:logo, "height must be under 100 pixels")
                end
            end
        end
    end
=end
end
