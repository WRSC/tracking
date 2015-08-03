class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :attempt_id
      t.integer :timecost  
      t.float :rawscore
      t.float :penalty 
      t.datetime :datetimes
      t.integer :rank 
     t.timestamps null: false
    end
  end
end
