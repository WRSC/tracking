class CreateListes < ActiveRecord::Migration
  def change
    create_table :listes do |t|
      t.string :latitude
      t.string :longitude
      t.string :datetime
      t.integer :tracker_id
      t.string :token

      t.timestamps null: false
    end
  end
end
