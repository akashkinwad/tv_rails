json.extract! nft_post, :id,
                    :title,
                    :description,
                    :category,
                    :hashtags,
                    :max_supply,
                    :status,
                    :token_uri,
                    :attachment_url,
                    :content_type,
                    :extension,
                    :user_id,
                    :details,
                    :offer_amount,
                    :start_price,
                    :target_price,
                    :end_date,
                    :nft_id,
                    :created_at,
                    :updated_at
json.user do
  json.partial! "api/v1/users/user", user: nft_post.user
end
