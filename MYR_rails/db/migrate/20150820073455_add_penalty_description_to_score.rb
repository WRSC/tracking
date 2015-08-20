class AddPenaltyDescriptionToScore < ActiveRecord::Migration
  def change
		add_column :scores, :penalty_description, :text
  end
end
