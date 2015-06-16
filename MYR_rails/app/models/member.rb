class Member < ActiveRecord::Base
# Associations
	belongs_to :team


# Validations
    validates :name, presence: true, uniqueness: true, length: { in: 3..30, too_long: "%{count} characters is the maximum allowed", too_short:"%{count} characters is the minimum allowed"  }
    has_secure_password
    validates :password, presence: true, confirmation: true, length: { in: 6..30, too_long: "%{count} characters is the maximum allowed", too_short:"%{count} characters is the minimum allowed"  }
    validates :email, presence: true, uniqueness: true, length: { in: 5..300, too_long: "%{count} characters is the maximum allowed", too_short:"%{count} characters is the minimum allowed"  }, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'must be a email address ex: exemple@ofE.mail'}
    validates :role, inclusion: { in: %w(administrator visitor player), message: "%{value} is not a valid role" }, allow_nil: true
    validates :logo, allow_blank: true, format: {with: %r{\.(gif|jpg|png)\Z}i, message: 'must be a URL for GIF, JPG or PNG image'}
    validate :valid_size
    def valid_size
        if self.logo != ""
            if FastImage.size(self.logo)!= nil
                if FastImage.size(self.logo)[0] > 150
                    errors.add(:logo, "width must be under 150 pixels")
                end
                if FastImage.size(self.logo)[1] > 150
                    errors.add(:logo, "height must be under 150 pixels")
                end
            end
        end
    end
end
