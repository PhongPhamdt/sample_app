class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  attr_reader :remember_token

  validates :name, presence: true,
  length: {maximum: Settings.maximum_name_length}

  validates :email, presence: true,
  length: {maximum: Settings.maximum_email_length},
  format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  validates :password, presence: true,
  length: {minimum: Settings.minimum_password_length}, allow_nil: true

  validates :gender, presence: true, inclusion: %w(male female)

  validates :date_of_birth,
    timeliness: {on_or_before: ->{Date.current}, type: :date}

  before_save{downcase}

  has_secure_password

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest string
    if (cost = ActiveModel::SecurePassword.min_cost)
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
    BCrypt::Password.create(string, cost: cost)
  end

  def remember
    @remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update remember_digest: nil
  end

  def current_user? _user
    self == _user
  end

  private
  def downcase
    email.downcase!
  end
end
