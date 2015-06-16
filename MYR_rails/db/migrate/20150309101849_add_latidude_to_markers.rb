class AddLatidudeToMarkers < ActiveRecord::Migration
  def change
    add_column :markers, :latitude, :float
  end
end
