class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, uniqueness: { case_sensitive: true }

  has_many :posts, dependent: :destroy
  has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow'
  has_many :followees, through: :followed_users
  has_many :following_users, foreign_key: :followee_id, class_name: 'Follow'
  has_many :followers, through: :following_users

  def generate_otp
    rand.to_s[2..7]
  end

  def generate_user_otp!
    self.mobile_otp = generate_otp
    self.otp_sent_at = Time.now.utc
    save(validate: false)
  end

  def otp_valid?
    # (self.otp_sent_at + 5.minutes) > Time.now.utc
    true
  end

  def generate_jwt
    JWT.encode(
      { id: id, exp: 90.days.from_now.to_i },
      Rails.application.secrets.secret_key_base
    )
  end
end
