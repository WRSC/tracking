class AddEnabledToTrakcers < ActiveRecord::Migration
  def change
    add_column :trackers, :enabled, :boolean, default: true
  end
end
