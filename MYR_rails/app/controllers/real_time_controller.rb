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

	def robots_panel
  		@trackers=[] # change js array into tracker_ids
  		if (params[:trackers] != nil) 
     	params[:trackers].each do |k,v|
    		@trackers << v
    	end
    	@current_mission_id = params[:mission_id]
  	end

	end

	def getNewTrackers
		last_refresh = params[:datetime]
		known_trackers = params[:trackers]
		current_mission_id = params[:mission_id]
		numMaxCoords = params[:numCoords]
		@test= IsThereNewTrackers?(last_refresh, known_trackers, current_mission_id, numMaxCoords)
		render json: 	@test
	end
	
	def getMissionBuoys
		current_mission_id = params[:mission_id]
		@buoys=Marker.where("mission_id = ?", current_mission_id)	
		render json: @buoys
	end	

	def trackerOfRobot
		current_mission_id = params[:mission_id]
		robot_id = params[:robot]
		trackers=[]
		attempts = Attempt.where("mission_id = ?", current_mission_id)
		attempts.each do |attempt|
			if attempt.robot_id.to_s == robot_id.to_s
				trackers.push(attempt.tracker_id)
			end
		end
		render json: trackers
	end

	def manageDispRobot
	end

end
