class AddHumainInteractionToScore < ActiveRecord::Migration
  def change
		 remove_column :scores, :penalty, :float
		 remove_column :scores, :penalty_description, :text
		 add_column    :scores, :timepenalty, :float
		 add_column    :scores, :timepenalty_description, :text
	   add_column    :scores, :humanintervention, :int
		 add_column    :scores, :AIS, :int
		
  end
end
