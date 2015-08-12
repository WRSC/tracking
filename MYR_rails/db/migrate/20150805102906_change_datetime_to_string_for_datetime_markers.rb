class ChangeDatetimeToStringForDatetimeMarkers < ActiveRecord::Migration
  def change
    remove_column :markers, :datetime, :datetime
    add_column    :markers, :datetime, :string
  end
end
