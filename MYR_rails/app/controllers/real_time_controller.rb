class RealTimeController < ApplicationController
	include RealTimeHelper

	def show
	end

	def getMissionLength
		render json: getMissionInfos
	end

	def map_panel
	end
	
	def choice_teams
			#-------------- HTML PRESENTATION ----------------------------------
		#-------- variables d instance passees a la vue -------------------
		@teams=Team.all #all the teams

		#creation of @tabteams to help for the generation of the HTML code 
		@strteams = cookies[:teamslist]
		if (@strteams != nil) #cannot split nil
			@tabteams = @strteams.split(",");
			@tabteams.sort! #to display the robot in the order of the teams
		else
			@tabteams = []
		end	
		#--------------------------------------------------------------------
	end
	
	def choice_robots
 	#------------------------------------------------------------------------------------
		#-------------- HTML PRESENTATION ----------------------------------
		#-------- variables d instance passees a la vue -------------------
		@teams=Team.all #all the teams

		#creation of @tabteams to help for the generation of the HTML code 
		@strteams = cookies[:teamslist]
		if (@strteams != nil) #cannot split nil
			@tabteams = @strteams.split(",");
			@tabteams.sort! #to display the robot in the order of the teams
		else
			@tabteams = []
		end	
		#--------------------------------------------------------------------

		#----------make sure that no robot from an unchecked team is checked---------------
		possiblerobots = []
		for i in 0..@tabteams.length-1
			possiblerobots += Robot.where(team_id: @tabteams[i]) #a list of all the robots to be displayed
		end

		possiblerobots2 = []
		possiblerobots.each do |robot|
			possiblerobots2.push(robot.id)#a list of all the id of the robot to be displayed
		end

		robots=[]
		str = cookies[:robotslist]
		if (str != nil)
			robots = str.split(",")
		end
		
		todelete = []
		for i in 0..robots.length-1
			if (possiblerobots2.index(robots[i].to_i) == nil )#if a robot is present despite the fact it should not be (team unchecked)
				todelete.push(robots[i])
			end
		end
		
		robots = robots - todelete #remove (and not delete ...) the undesired robot

		cookies[:robotslist] = robots.join(",") # modify the cookie after having delete undesired robots
		#----------------------------------------------------------------------------------
 	end

	def getNewTrackers
		last_refresh = params[:datetime]
		known_trackers = params[:trackers]
		render json: IsThereNewTrackers?(last_refresh, known_trackers)
	end
end
