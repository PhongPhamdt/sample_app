class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true,
  length: {maximum: Settings.maximum_name_length}

  validates :email, presence: true,
  length: {maximum: Settings.maximum_email_length},
  format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  validates :password, presence: true,
  length: {minimum: Settings.minimum_password_length}

  before_save{downcase}

  has_secure_password

  private
  def downcase
    self.email.downcase!
  end
end