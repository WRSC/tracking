class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :attempt_id  
      t.float :penalty 
    end
  end
end
