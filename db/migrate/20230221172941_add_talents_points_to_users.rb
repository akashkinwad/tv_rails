class AddTalentsPointsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :talents_points, :integer, default: 0
  end
end
