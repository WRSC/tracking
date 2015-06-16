class AddTrackeridToRobot < ActiveRecord::Migration
  def change
    add_column :robots, :tracker_id, :integer
  end
end
