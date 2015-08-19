class AddMissionStartTimeWhenIsRace < ActiveRecord::Migration
  def change
  	add_column :missions, :startOfRace, :string
  end
end
