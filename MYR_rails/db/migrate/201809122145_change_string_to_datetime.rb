class ChangeStringToDatetime < ActiveRecord::Migration
  def up
    change_column :coordinates, :datetime, :datetime
  end

  def down
    change_column :coordinates, :datetime, :string
  end
end
