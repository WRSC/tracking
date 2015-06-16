class RemoveLatitudeFromMarkers < ActiveRecord::Migration
  def change
    remove_column :markers, :latitude, :decimal
  end
end
