class AddFinalscoreToScore < ActiveRecord::Migration
  def change
		add_column    :scores, :finalscore, :decimal  
	end
end
