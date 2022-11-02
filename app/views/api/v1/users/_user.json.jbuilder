json.extract! user,:id,
                   :email,
                   :created_at,
                   :updated_at,
                   :username,
                   :verified,
                   :mobile,
                   :first_name,
                   :last_name,
                   :daily_news,
                   :image_url,
                   :video_url,
                   :mobile_otp,
                   :otp_sent_at,
                   :blr_image
json.followers_count user.following_users.count
json.following_count user.followed_users.count
