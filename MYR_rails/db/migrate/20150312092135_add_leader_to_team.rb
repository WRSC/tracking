class AddLeaderToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :leader_id, :integer
  end
end
