class RealTimeController < ApplicationController
	include RealTimeHelper

	def show
	end
	
	def map_panel
	end
	
	def getMissions
		render json: getMissionIds
	end
	
	def getNewTrackers
		last_refresh = params[:datetime]
		@last_refresh=last_refresh
		known_trackers = params[:trackers]
		current_mission_id = params[:mission_id]
		@test= IsThereNewTrackers?(last_refresh, known_trackers, current_mission_id)
		#render json: @test
	end
end
