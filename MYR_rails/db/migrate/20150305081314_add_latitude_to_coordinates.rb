class AddLatitudeToCoordinates < ActiveRecord::Migration
  def change
    add_column :coordinates, :latitude, :float
  end
end
