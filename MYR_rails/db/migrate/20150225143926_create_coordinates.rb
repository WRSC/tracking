class CreateCoordinates < ActiveRecord::Migration
  def change
    create_table :coordinates do |t|
      t.decimal :latitude
      t.decimal :longitude
      t.datetime :datetime
      t.integer :tracker_id
      t.string :token

      t.timestamps null: false
    end
  end
end
