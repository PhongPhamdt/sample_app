class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  attr_reader :remember_token

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

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by id: user_id
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by id: user_id
      if user&.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
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

  private
  def downcase
    email.downcase!
  end
end
