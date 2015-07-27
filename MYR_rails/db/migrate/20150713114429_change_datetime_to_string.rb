class ChangeDatetimeToString < ActiveRecord::Migration
  def change
  	remove_column :coordinates, :datetime, :datetime

  	add_column :coordinates, :datetime, :string
  end

end
