class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true,
  length: {maximum: Settings.maximum_name_length}

  validates :email, presence: true,
  length: {maximum: Settings.maximum_email_length},
  format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  validates :password, presence: true,
  length: {minimum: Settings.minimum_password_length}

  validates :gender, presence: true, inclusion: %w(male female)

  validates :date_of_birth,
    timeliness: {on_or_before: ->{Date.current}, type: :date}

  before_save{downcase}

  has_secure_password

  def self.digest string
    if (cost = ActiveModel::SecurePassword.min_cost)
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
    BCrypt::Password.create(string, cost: cost)
  end

  private
  def downcase
    email.downcase!
  end
end
