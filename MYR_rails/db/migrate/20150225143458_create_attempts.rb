class CreateAttempts < ActiveRecord::Migration
  def change
    create_table :attempts do |t|
      t.string :name
      t.datetime :start
      t.datetime :end
      t.integer :robot_id
      t.integer :mission_id
      t.integer :tracker_id

      t.timestamps null: false
    end
  end
end
