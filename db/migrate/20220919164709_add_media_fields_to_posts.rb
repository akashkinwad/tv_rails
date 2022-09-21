class AddMediaFieldsToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :url, :string
    add_column :posts, :content_type, :string
    add_column :posts, :extension, :string
  end
end
