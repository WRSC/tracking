class Tracker < ActiveRecord::Base
# Associations
has_many :attempt		
has_many :coordinate		


# Validations
before_create :generate_token
validates :token, presence: true, uniqueness: true
private
def generate_token
    begin
        self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
end
end
