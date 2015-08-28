class AddAispointsToRobots < ActiveRecord::Migration
  def change
		add_column    :robots, :aispoints, :int  
	end
end
