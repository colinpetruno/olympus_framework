class AddUnconfirmedEmailField < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :unconfirmed_email, :string
  end
end
