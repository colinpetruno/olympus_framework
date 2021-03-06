class AddColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :blah, :string
  end
end
