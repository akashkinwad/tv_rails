class RenameHashtagColumnOfPosts < ActiveRecord::Migration[7.0]
  def change
    rename_column :posts, :hastag, :hashtag
  end
end
