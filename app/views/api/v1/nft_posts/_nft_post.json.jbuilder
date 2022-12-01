json.extract! nft_post, :id,
                    :title,
                    :description,
                    :category,
                    :hashtags,
                    :listing_price,
                    :quantity,
                    :status,
                    :token_uri,
                    :attachment_url,
                    :user_id,
                    :content_type,
                    :extension,
                    :details,
                    :created_at,
                    :updated_at
json.user do
  json.partial! "api/v1/users/user", user: nft_post.user
end
