class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name
      t.string :password
      t.string :email
      t.string :role
      t.string :logo
      t.integer :team_id

      t.timestamps null: false
    end
  end
end
