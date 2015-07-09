class RealTimeController < ApplicationController
	include RealTimeHelper

	def show
	end
	
	def map_panel
	end

	def options_panel
	end
	
	def getMissions
		render json: getMissionIds
	end
	
	def	update_map
		@current_mission_id= params[:mission_id]
	end
	
	def	update_map_auto
		@current_mission_id= params[:mission_id]
	end

	def getNewTrackers
		
		last_refresh = params[:datetime]
		known_trackers = params[:trackers]
		current_mission_id = params[:mission_id]
		@test= IsThereNewTrackers?(last_refresh, known_trackers, current_mission_id)
		render json: 	@test
	end
	
	def getMissionBuoys
		current_mission_id = params[:mission_id]
		@buoys=Marker.where("mission_id = ?", current_mission_id)	
		render json: @buoys
	end	

end
