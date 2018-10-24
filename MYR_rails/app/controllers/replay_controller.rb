 class ReplayController < ApplicationController
	def show 
	end
	
	def replay_map_panel
		#------------------------------------------------------------------------------------
		#------------ GATHERING ALL THE DESIRED COORDINATES-----------------------------
		@coordinatesCustom = [] #create an empty array where adding desired coordinates
		tab = []
		
		robots=[]
		str = cookies[:robotslist]
		if (str != nil)
			robots = str.split(",")
		end
		if (str != nil) #cannot split nil
			tab = str.split(","); # see what happen if tab only have one element and no ','
		end
		@testRobots=robots
		@testTab=tab
		tabtrack=[]
		
		for i in (0..(tab.length-1)) # skip the loop if tab = []
			@tab0=Robot.find_by_id(tab[i])
			@tracker_id=Tracker.find_by_id(Robot.find_by_id(tab[i]).tracker_id)
			if (Tracker.find_by_id(Robot.find_by_id(tab[i]).tracker_id) !=nil)
				tabtrack.push((Tracker.find_by_id(Robot.find_by_id(tab[i]).tracker_id)).id) #recursively add the coordinates
			end
		end
		@tabtrack=tabtrack		
		for i in (0..(tabtrack.length-1)) # skip the loop if tab = []
			@coordinatesCustom += Coordinate.where(tracker_id: tabtrack[i]); #recursively add the coordinates
		end
		#----------------------------------------------------------------------------------

		#---------------------------- START Limite coordinate -----------------
		mycoordinatesCustom=@coordinatesCustom.reverse
		sortie=[]
		p=1 
		q=1
		nbpts=0
		nbptsmax=125
		tra=0
		nbtra=tabtrack.length
		if mycoordinatesCustom != nil
			for j in 0..mycoordinatesCustom.length-1
				if mycoordinatesCustom[j]!= nil
					if mycoordinatesCustom[j].tracker_id != tra
						tra = mycoordinatesCustom[j].tracker_id
						p=1
						q=1
						nbpts=0
					end
					if nbpts < nbptsmax/nbtra
						if q%p == 0
							sortie=sortie+[mycoordinatesCustom[j]]
							nbpts=nbpts+1
						end
					end
					if q>=60*p
						p=10*p
					end
					q=q+1
				end
			end
		end
		@coordinatesCustom=sortie.reverse
		#---------------------------- FIN Limite coordinate -----------------
		#------------------------------------------------------------------------------------	
	end
	#------------------------------------------------------------------------------------
	
	def choice_editions
		@editions = Edition.all
	end

	def choice_teams
			#-------------- HTML PRESENTATION ----------------------------------
		#-------- variables d instance passees a la vue -------------------
		
		@teams=Team.all #all the teams
		#creation of @tabteams to help for the generation of the HTML code 
		@testCookies=cookies
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
 	
 	def choice_onerobot
 	end
 	
 	def choice_replay_missions
 		#--------------Help the generation of html for missions----------------------------
		strrobots = cookies[:robotslist]
		if (strrobots != nil)
			@indrobots = strrobots.split(",") #list of index of the robots to display
		else
			@indrobots = []
		end	

		strteams = cookies[:teamslist] 
		if (strteams != nil) #cannot split nil
			@indteams = strteams.split(","); #list of index of the team to display
		else
			@indteams = []
		end	

		@strmissions = cookies[:missionslist]
		#----------------------------------------------------------------------------------
 	end
 	
 	def choice_attempts
 		#--------------Help the generation of html for missions----------------------------
		strrobots = cookies[:robotslist]
		if (strrobots != nil)
			@indrobots = strrobots.split(",") #list of index of the robots to diplay
		else
			@indrobots = []
		end	

		strteams = cookies[:teamslist] 
		if (strteams != nil) #cannot split nil
			@indteams = strteams.split(","); #list of index of the team to display
		else
			@indteams = []
		end	
		@strmissions = cookies[:missionslist]
		#----------------------------------------------------------------------------------
 	end
 	
 	def update_replay_map
 		@attempts = cookies[:attemptslist]
 	end
 	
 	def getSingleAttemptInfos
 		# Need start time, end time, tracker_id (each attempt has only one tracker)
 		attempt_id = cookies[:attemptslist]
 		attempt = Attempt.find_by(id: attempt_id)
 		tstart = attempt.start.strftime("%Y-%m-%d %H:%M:%S")
 		tend = attempt.end.strftime("%Y-%m-%d %H:%M:%S")
 		render json: [tstart, tend, attempt.tracker_id]
 	end
 	
 	def getTrackersFromDatetimes
 		trackers=[]
 		rob_ids=params[:robs]
 		robs=rob_ids.split(",")
 		tstart=params[:tstart].to_datetime
 		tend=params[:tend].to_datetime
 		
		attempts=Attempt.where(robot_id: robs).where("start > ? AND end < ?", tstart, tend)
 		attempts.each do |attempt|
			trackers.push(attempt.tracker_id)
		end
 		render json: trackers
 	end
 	
 	def choice_datetimes
 	end

	def officialMarkersInfo
		strmissions = cookies[:missionslist]
		if (strmissions != nil) #cannot split nil
			tabm = strmissions.split(","); 
		else
			tabm = []
		end	
		markerinfos=Marker.where(mission_id: tabm)
		render json: markerinfos.to_json(:only =>[:mtype,:latitude,:longitude,:datetime, :name, :description])
	end
 	
	def infoAttempt
		singleAttempt=params[:singleAttempt]
		res = []
		if singleAttempt=='true'
		 	a_id=cookies[:attemptslist].to_i
		 	myAttempt = Attempt.find_by(id: a_id)
		 	mission = Mission.find(myAttempt.mission_id)
		 	robot = Robot.find(myAttempt.robot_id)
			res.push(myAttempt)
			res.push(robot)
			res.push(mission)
			res.push(Team.find(robot.team_id))
	 	end
	 	render json: res.to_json
	end

end
