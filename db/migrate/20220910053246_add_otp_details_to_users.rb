class AddOtpDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :mobile_otp, :string
    add_column :users, :otp_sent_at, :datetime
  end
end
