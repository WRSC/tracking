class AddLongitudeToCoordinates < ActiveRecord::Migration
  def change
    add_column :coordinates, :longitude, :float
  end
end
