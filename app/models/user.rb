class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true
  validates :email, uniqueness: true

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.authenticate(password)
      user
    else
      nil
    end
  end
end
