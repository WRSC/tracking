class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.string :token
      t.integer :description

      t.timestamps null: false
    end
  end
end
