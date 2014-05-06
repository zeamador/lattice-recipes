class User < ActiveRecord::Base
  VALID_NAME_REGEX = /\A[a-z\d\-.]+\z/i
  validates(:name, presence: true, length: { maximum: 20, minimum: 5}, format: { with: VALID_NAME_REGEX }, uniqueness: { case_sensitive: false })
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false })
  before_save { self.email = email.downcase }
end
