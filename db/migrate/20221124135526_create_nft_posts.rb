class CreateNftPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :nft_posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :category
      t.text :hashtags
      t.decimal :listing_price
      t.integer :quantity
      t.string :status
      t.string :token_uri
      t.string :attachment_url
      t.string :content_type
      t.string :extension
      t.jsonb :details

      t.timestamps
    end
  end
end
