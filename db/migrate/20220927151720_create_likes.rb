class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.references :likeable, polymorphic: true, null: false
      t.integer :value, default: 0

      t.timestamps
    end
  end
end
