class RemoveLatitudeFromCoordinates < ActiveRecord::Migration
  def change
    remove_column :coordinates, :latitude, :decimal
  end
end
