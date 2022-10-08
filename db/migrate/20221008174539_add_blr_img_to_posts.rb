class AddBlrImgToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :blr_image, :string
  end
end
