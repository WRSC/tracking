class AddCategoryToMissions < ActiveRecord::Migration
  def change
  	add_column :missions, :category, :string
  end
end
