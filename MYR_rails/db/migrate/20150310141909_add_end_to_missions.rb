class AddEndToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :end, :datetime
  end
end
