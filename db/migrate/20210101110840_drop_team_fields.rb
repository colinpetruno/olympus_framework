class DropTeamFields < ActiveRecord::Migration[6.0]
  def change
    remove_column :profiles, :team_id
  end
end
