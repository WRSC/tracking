class AddMargintenToScore < ActiveRecord::Migration
  def change
		add_column    :scores, :marginten, :int
  end
end
