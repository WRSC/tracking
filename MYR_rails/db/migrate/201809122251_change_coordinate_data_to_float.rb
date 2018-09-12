class ChangeCoordinateDataToFloat < ActiveRecord::Migration
  def up
    change_column :coordinates, :latitude, :float
    change_column :coordinates, :longitude, :float
    change_column :coordinates, :speed, :float
    change_column :coordinates, :course, :float
  end

  def down
    change_column :coordinates, :latitude, :string
    change_column :coordinates, :longitude, :string
    change_column :coordinates, :speed, :string
    change_column :coordinates, :course, :string
  end
end
