class AddDeviseMemberPasswordFields < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :encrypted_password, :string, null: false, default: ""
    add_column :members, :reset_password_token, :string
    add_column :members, :reset_password_sent_at, :datetime
    add_column :members, :confirmation_token, :string
    add_column :members, :confirmed_at, :datetime
    add_column :members, :confirmation_sent_at, :datetime
  end
end
