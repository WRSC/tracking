class ChangeLatlngtypeAddTypeToMarkers < ActiveRecord::Migration
    def change
  	remove_column :markers, :latitude, :float
  	add_column :markers, :latitude, :string

  	remove_column :markers, :longitude, :float
  	add_column :markers, :longitude, :string

		add_column :markers, :type, :string
  end
end
