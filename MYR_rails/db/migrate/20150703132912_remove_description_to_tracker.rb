class RemoveDescriptionToTracker < ActiveRecord::Migration
  def change
  	remove_column :trackers, :description, :integer
  end
end
