class AddMissionType < ActiveRecord::Migration
  def change
  	remove_column :missions, :description, :text
  	add_column :missions, :type, :string
  end
end
