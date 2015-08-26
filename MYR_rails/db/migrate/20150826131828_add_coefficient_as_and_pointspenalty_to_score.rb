class AddCoefficientAsAndPointspenaltyToScore < ActiveRecord::Migration
  def change
#area scanning coefficent
		add_column    :scores, :ascoef, :decimal
		add_column    :scores, :pointpenalty, :decimal
		add_column    :scores, :pointpenalty_description, :text
	end
end
