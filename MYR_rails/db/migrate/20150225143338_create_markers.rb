class CreateMarkers < ActiveRecord::Migration
  def change
    create_table :markers do |t|
      t.string :name
      t.text :description
      t.decimal :latitude
      t.decimal :longitude
      t.datetime :datetime
      t.integer :mission_id

      t.timestamps null: false
    end
  end
end
