class ChangeTypeToMtype < ActiveRecord::Migration
  def change
  	remove_column :missions, :type, :string
  	add_column :missions, :mtype, :string
  end
end
