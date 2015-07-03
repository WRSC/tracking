class AddStringDescriptionToTracker < ActiveRecord::Migration
  def change
  	add_column :trackers, :description, :string
  end
end
