class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string, uniq: true
    add_column :users, :verified, :boolean, default: false
    add_column :users, :mobile, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :daily_news, :text
    add_column :users, :image_url, :string
    add_column :users, :video_url, :string
  end
end
