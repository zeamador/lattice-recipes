class User < ActiveRecord::Base
  
  # Valid username: 
  # 5-20 characters
  # letters, digits, - or .
  # case insensitive
  # unique
  VALID_NAME_REGEX = /\A[a-z\d\-.]+\z/i
  validates(:name, presence: true, length: { maximum: 20, minimum: 5}, 
            format: { with: VALID_NAME_REGEX }, 
            uniqueness: { case_sensitive: false })
  
  # Valid email:
  # * @ * . *
  # case insensitive
  # unique
  # in database, save in lowercase
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
            uniqueness: { case_sensitive: false })
  before_save { self.email = email.downcase }

  # Valid password:
  # 6-20 characters
  # letters, digits, - or .
  
  # check password
  has_secure_password
  VALID_PASSWORD_REGEX = /\A[a-z\d\-.]+\z/i
  validates(:password, length: { maximum: 20, minimum: 6 }, 
            format: { with: VALID_PASSWORD_REGEX })

end
