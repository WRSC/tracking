class RemoveLongitudeFromMarkers < ActiveRecord::Migration
  def change
    remove_column :markers, :longitude, :decimal
  end
end
