class AddStartToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :start, :datetime
  end
end
