class ChangeTrackersDescriptionIntegerToString < ActiveRecord::Migration
  def change

  	remove_column :trackers, :description, :integer

  	add_column :trackers, :description, :string

  end
end
