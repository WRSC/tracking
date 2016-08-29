class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.string :name
      t.integer :edition_id
      t.timestamps null: false
    end
  end
end
