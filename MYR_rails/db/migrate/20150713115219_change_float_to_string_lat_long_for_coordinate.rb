class ChangeFloatToStringLatLongForCoordinate < ActiveRecord::Migration
  def change
  	remove_column :coordinates, :latitude, :float

  	add_column :coordinates, :latitude, :string
  	remove_column :coordinates, :longitude, :float

  	add_column :coordinates, :longitude, :string
  end
end
