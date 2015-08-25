class AddBestscoreToRobots < ActiveRecord::Migration
  def change
		add_column    :robots, :bestscore, :float
  end
end
