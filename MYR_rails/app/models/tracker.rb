class Tracker < ActiveRecord::Base
# Associations
has_many :attempts		
has_many :coordinates	


# Validations
before_create :generate_token
#validates :token, presence: true, uniqueness: true
private
def generate_token
    begin
        self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
end
end
