class RemoveList < ActiveRecord::Migration
  def change
  	drop_table :listes
  end
end
