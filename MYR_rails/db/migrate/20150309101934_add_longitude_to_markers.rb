class AddLongitudeToMarkers < ActiveRecord::Migration
  def change
    add_column :markers, :longitude, :float
  end
end
