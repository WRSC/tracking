class AddBestscoreIdAndFinalrankToRobot < ActiveRecord::Migration
  def change
		  remove_column :robots, :bestscoreId, :int
		 add_column :robots, :finalrank, :int  
	end
end
