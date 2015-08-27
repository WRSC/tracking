class ChangeBestscoreToBestfourscores < ActiveRecord::Migration
  def change
		remove_column :robots, :bestscoreId, :integer
		remove_column :robots, :bestscore, :integer
#triangular
		add_column    :robots, :bestTriangulartime, :decimal
		add_column    :robots, :bestTriangularscoreId, :int
		add_column    :robots, :triangularRank, :int
#stationkeeping
		add_column    :robots, :bestStationscore, :float
		add_column    :robots, :bestStationscoreId, :int
		add_column    :robots, :stationRank, :int
#area scanning
		add_column    :robots, :bestAreascore, :float
		add_column    :robots, :bestAreascoreId, :int
		add_column    :robots, :areaRank, :int
#fleet race
		add_column    :robots, :bestRacetime, :decimal
		add_column    :robots, :bestRacescoreId, :int
		add_column    :robots, :raceRank, :int
#final score
		add_column    :robots, :finalscore, :float
  end
end
