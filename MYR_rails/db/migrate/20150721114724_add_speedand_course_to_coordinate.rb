class AddSpeedandCourseToCoordinate < ActiveRecord::Migration
  def change
  	add_column :coordinates, :speed, :string

  	add_column :coordinates, :course, :string
  end
end
