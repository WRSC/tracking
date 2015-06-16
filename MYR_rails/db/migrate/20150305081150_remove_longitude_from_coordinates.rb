class RemoveLongitudeFromCoordinates < ActiveRecord::Migration
  def change
    remove_column :coordinates, :longitude, :decimal
  end
end
