class AddEditionIdToMissions < ActiveRecord::Migration
  def change
  	add_column    :missions, :edition_id, :int   
  end
end
