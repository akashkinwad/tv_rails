class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts

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
