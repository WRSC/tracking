module SessionsHelper
  def sign_in(user)
    session[:user_id] = user.id
    self.current_user=user
  end
  
  def sign_out
  	forget(current_user)
    session.delete(:user_id)
		self.current_user=nil
  end
  
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def current_user 
    if (user_id = session[:user_id])
      @current_user ||= Member.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = Member.find_by(id: user_id)
      if user && user.authenticated?(:remember,cookies[:remember_token])
        sign_in(user)
        @current_user = user
      end
    end
  end
  
  def current_user=(user)
    @current_user = user
  end

  def tabToString(tab)
	rep=""
	if tab != nil
		if tab.size>0
			if tab.size>1
				for i in 0..tab.size-2
					rep=rep+tab[i].to_s+", "
				end
			end
			rep=rep+tab[tab.size-1].to_s
		end
	end
	return rep
  end
  
  def stringToTab(myString)
	rep=[]
	if myString != nil
		rep = myString.split(",")
	end
	return rep
  end
  
  
  def sign_in?
    !current_user.nil?
  end
  
  def sign_A?
	rep=false
	if !current_user.nil?
		if current_user.role=="administrator"
			rep=true
		end
	end
    
  end
  
  def is_admin?
  	rep = false
  	if current_user != nil
		if current_user.role=="administrator"
			rep=true
		end
	end
	return rep
	
  end
  
  def is_leader?
	rep=false
	if Team.first != nil
		for i in Team.first.id..Team.last.id
			myVar=Team.find_by_id(i)
			if myVar != nil
				if current_user.id == myVar.leader_id
					rep=true
				end
			end
		end
	end
	return rep
  end



  def is_leader(nameTeam)
	rep=false
	if current_user != nil
		myVar=Team.find_by_name(nameTeam)
		if myVar != nil
			if current_user.id == myVar.leader_id
				rep=true
			end
		end
	end
	return rep
  end
  
  def is_memberById(idTeam)
	rep=false
	if myTeam != nil
		if myTeam.id==idTeam
			rep=true
		end
	end
	return rep
  end
  
  
  def is_leaderById(idTeam)
  	rep=false
  	if current_user != nil
  		myVar=Team.find_by_id(idTeam)
		if myVar != nil
			if current_user.id == myVar.leader_id
				rep=true
			end
		end
	end
	return rep
  end
  
  def isInTeam?
	rep=false
	if current_user != nil
		if current_user.team.id != nil
			if Team.find_by_id(current_user.team.id) != nil
				rep = true
			end
		end
	end
	return rep
  end

  def heIsInTeam?(nameMember)
	rep=false
	myVar=Member.find_by_name(nameMember)
	if myVar != nil
		if myVar.team.id != nil
			if Team.find_by_id(myVar.team.id) != nil
				rep = true
			end
		end
	end
	return rep
  end
  
  def heIsLeader?(nameMember)
	rep=false
	myVar = Member.find_by_name(nameMember)
	if myVar != nil
		if myVar.team.id != nil
			if Team.first != nil
				for i in Team.first.id..Team.last.id
					if Team.find_by_id(i) != nil
						if Team.find_by_id(i).leader_id == myVar.id
							rep=true
						end
					end
				end
			end
		end
	end
	return rep
  end
  
  def myTeam
	rep=nil
	if current_user != nil
		if current_user.team.id != nil
			rep = Team.find_by_id(current_user.team.id)
		end
	end
	return rep
  end
=begin
  def myTracker
	rep=nil
	if myTeam != nil
		if Robot.find_by_team_id(myTeam.id) != nil
			rep = Tracker.where(id: Robot.find_by_team_id(myTeam.id).tracker_id)
		end
	end
	return rep
  end
=end

  def hisTeam(nameMember)
	rep=nil
	myVar=Member.find_by_name(nameMember)
	if myVar != nil
		myVar = myVar.team.id
		if myVar != nil
			rep = Team.find_by_id(myVar)
		end
	end
	return rep
  end
  

  def nil.id
	return 0
  end
  

  
  def addOnMyTeam(newUser)
  	if newUser != nil
  		if newUser.team.id == nil # if newUser has no team
		  	if current_user != nil
		  		if current_user.team.id != nil
		  			myVar=Team.find_by_id(current_user.team.id)
					if myVar != nil
						if myVar.leader_id == current_user.id
							newUser.update(:team => myVar)
						end
					end
				end
			end
		end
	end
  end
  

  def trackerAvailable
  	allTrakersAvailable=[]
  	allTrakersNotAvailable=[]
  	allTrackers=[]
  	if Tracker.first != nil
  		allTrackers = Tracker.ids
  		if Attempt.first != nil
  			date=Date.current
  			attemptsInProgress = Attempt.where('end > ?',date)
  			if attemptsInProgress != []
  				for i in attemptsInProgress
  					if i.tracker_id != nil
  						allTrakersNotAvailable=allTrakersNotAvailable+[i]
  					end
  				end
  			end
  		end
  	end
  	allTrakersAvailable=allTrackers-allTrakersNotAvailable
  	return allTrakersAvailable
  end

  def allMembersInATeam(myTeam)
	rep=[]
	if Member.first != nil
		rep= Member.where(team: myTeam).ids
	end
	return rep
  end

  def sortId(tabId)
	rep=tabId
	if cookies[:Sort] == "Name" || cookies[:Sort] == "Namebis"
		rep=sortIdByName(tabId)
	
	elsif cookies[:Sort] == "Email" || cookies[:Sort] == "Emailbis"
		rep=sortIdByEmail(tabId)
	
	elsif cookies[:Sort] == "Role" || cookies[:Sort] == "Rolebis"
		rep=sortIdByRole(tabId)
		
	elsif cookies[:Sort] == "Team" || cookies[:Sort] == "Teambis"
		rep=sortIdByTeam(tabId)
		
	elsif cookies[:Sort] == "NameT" || cookies[:Sort] == "NameTbis"
		rep=sortTeamByName(tabId)
		
	elsif cookies[:Sort] == "NameR" || cookies[:Sort] == "NameRbis"
		rep=sortRobotByName(tabId)
		
	elsif cookies[:Sort] == "CategotyR" || cookies[:Sort] == "CategotyRbis"
		rep=sortRobotByCategory(tabId)
		
	elsif cookies[:Sort] == "TrackerR" || cookies[:Sort] == "TrackerRbis"
		rep=sortRobotByTracker(tabId)
		
	elsif cookies[:Sort] == "TeamR" || cookies[:Sort] == "TeamRbis"
		rep=sortRobotByTeam(tabId)
		
	elsif cookies[:Sort] == "NameM" || cookies[:Sort] == "NameMbis"
		rep=sortMissionByName(tabId)
		
	elsif cookies[:Sort] == "TypeM" || cookies[:Sort] == "TypeMbis"
		rep=sortMissionByType(tabId)
		
	elsif cookies[:Sort] == "TeamT"|| cookies[:Sort] == "TeamTbis"
		rep=sortTryByTeam(tabId)
		
	elsif cookies[:Sort] == "RobotT"|| cookies[:Sort] == "RobotTbis"
		rep=sortTryByRobot(tabId)	
		
	elsif cookies[:Sort] == "MissionT"|| cookies[:Sort] == "MissionTbis"
		rep=sortTryByMission(tabId)	

	elsif cookies[:Sort] == "TeamN" || cookies[:Sort] == "TeamNbis"
		rep=sortTeamByName(tabId)

	elsif cookies[:Sort] == "AttemptN" || cookies[:Sort] == "AttemptNbis"
		rep=sortAttemptByName(tabId)

	elsif cookies[:Sort] == "AttemptR" || cookies[:Sort] == "AttemptRbis"
		rep=sortAttemptByRobot(tabId)

	elsif cookies[:Sort] == "AttemptT" || cookies[:Sort] == "AttemptTbis"
		rep=sortAttemptByTracker(tabId)

	elsif cookies[:Sort] == "AttemptM" || cookies[:Sort] == "AttemptMbis"
		rep=sortAttemptByMission(tabId)

	elsif cookies[:Sort] == "TrackerID" || cookies[:Sort] == "TrackerIDbis"
		rep=sortTrackerByName(tabId)

	elsif cookies[:Sort] == "MissionN" || cookies[:Sort] == "MissionNbis"
		rep=sortMissionByName(tabId)
	end

	
	if cookies[:Sort] !=nil && cookies[:Sort] != ""
		if cookies[:Sort].include? ("bis")
			rep=rep.reverse
		end
	end
	
	cookies.delete(:Sort)
	cookies.delete(:Sort, :path => '/missions')
	return rep
  end
  
  def sortIdByName(tabId)
	rep=[]
	names=[]

	if tabId != nil
		for i in 0 .. (tabId.size-1)
			if  Member.find_by_id(tabId[i]) != nil
				names << Member.find_by_id(tabId[i]).name
			end
		end
		namesSort=names.sort
		for i in 0 .. (namesSort.size-1)
			rep << Member.find_by_name(namesSort[i]).id
		end
	end	
	return rep
  end

    def sortIdByEmail(tabId)
	rep=[]
	emails=[]
	if tabId != nil
		for i in 0 .. (tabId.size-1)
			if  Member.find_by_id(tabId[i]) != nil
				emails << Member.find_by_id(tabId[i]).email
			end
		end
		emailsSort=emails.sort
		for i in 0 .. (emailsSort.size-1)
			rep << Member.find_by_email(emailsSort[i]).id
		end
	end	
	return rep
  end
  
    def sortIdByRole(tabId)
	rep=[]
	visitors=[]
	if tabId != nil
		for i in 0 .. (tabId.size-1)
			if  Member.find_by_id(tabId[i]) != nil
				role=Member.find_by_id(tabId[i]).role
				if role == "administrator"
					rep=[tabId[i]]+rep
				
				elsif role == "player"
					rep=rep+[tabId[i]]
				
				elsif role == "visitor"
					visitors << tabId[i]
				end
			end
		end
		rep= rep+visitors
	end	
	return rep
  end
  

  def sortIdByTeam(tabId)
	rep=[]
	cal1=[] 
	cal2=[]
	cal3=[]
	cal4=[]
	teamNames=[]
	allTeamsId=Team.ids # tout les membre qui on une team, non trié

	if allTeamsId != nil && allTeamsId != []
		for i in 0 .. (allTeamsId.size-1)
			if  Team.find_by_id(allTeamsId[i]) != nil
				teamNames << Team.find_by_id(allTeamsId[i]).name
			end
		end

		teamNamesSort=teamNames.sort

		for i in 0 .. (teamNamesSort.size-1)
			myVar = Team.find_by_name(teamNamesSort[i])
			cal1=cal1+Member.where(team: myVar).ids# tout les membre qui on une team, trié
			if cal1 != []
				for ii in 0..cal1.size-1
					cal1[ii]=cal1[ii].to_i
				end
			end

			cal2= cal1 -tabId # tout les membre qui on une team et que l'on ne veux pas trié, trié

			cal3= cal1 - cal2 # tout les membre qui on  une team et que l'on  veux  trié, trié

			cal4=tabId -cal3# tout les membre qui n'on pas de team et que l'on veux trié, non trié
			
			cal5=sortIdByName(cal4)#tout les membre qui n'on pas de team et que l'on veux trié, trié

			rep= cal5+cal3
		end
	else
		rep=tabId
	end
	return rep
  end
  
  def sortTeamByName(tabTeamId)
	rep=[]
	teamNames=[]
	allTeamsId=tabTeamId 
	if allTeamsId != nil
		for i in 0 .. (allTeamsId.size-1)
			if  Team.find_by_id(allTeamsId[i]) != nil
				teamNames << Team.find_by_id(allTeamsId[i]).name
			end
		end
		teamNamesSort=teamNames.sort
		for i in 0 .. (teamNamesSort.size-1)
			rep << Team.find_by_name(teamNamesSort[i]).id 
		end
	end
	return rep
  end
  
    def sortRobotByName(tabRobotId)
	rep=[]
	robotNames=[] 
	if tabRobotId != nil
		for i in 0 .. (tabRobotId.size-1)
			if  Robot.find_by_id(tabRobotId[i]) != nil
				robotNames << Robot.find_by_id(tabRobotId[i]).name
			end
		end
		robotNamesSort=robotNames.sort
		for i in 0 .. (robotNamesSort.size-1)
			rep << Robot.find_by_name(robotNamesSort[i]).id
		end
	end
	return rep
  end
  
  
  def sortRobotByCategory(tabRobotId)
	rep=[]
	smalls=[]
	mediums=[]
	bigs=[] 
	motors=[]
	others=[]
	if tabRobotId != nil
		for i in 0 .. (tabRobotId.size-1)
			if  Robot.find_by_id(tabRobotId[i]) != nil
				cate=Robot.find_by_id(tabRobotId[i]).category
				if cate == "Small"
					smalls << tabRobotId[i]
				
				elsif cate == "Medium"
					mediums << tabRobotId[i]
				
				elsif cate == "Big"
					bigs << tabRobotId[i]
				elsif cate == "Motor"
					motors << tabRobotId[i]
				else
					others << tabRobotId[i]
				end
			end
		end
		rep=sortRobotByName(smalls)+sortRobotByName(mediums)+sortRobotByName(bigs)+sortRobotByName(motors)+sortRobotByName(others)
	end
	return rep
  end
=begin  
  def sortRobotByTracker(tabRobotId)
	rep=[]
	robotTrackerId=[] 
	robotTrackerIdnil=[]
	if tabRobotId != nil
		for i in 0 .. (tabRobotId.size-1)
			if  Robot.find_by_id(tabRobotId[i]) != nil
				if Robot.find_by_id(tabRobotId[i]).tracker_id != nil
					robotTrackerId << Robot.find_by_id(tabRobotId[i]).tracker_id
				else
					robotTrackerIdnil=robotTrackerIdnil+[tabRobotId[i]]
				end
			end
		end
		robotTrackerIdSort=robotTrackerId.sort
		for i in 0 .. (robotTrackerIdSort.size-1)
			rep << Robot.find_by_tracker_id(robotTrackerIdSort[i]).id # tout les membre qui on une team, trié
		end
	end
	rep=robotTrackerIdnil+rep
	return rep
  end
=end  
    def sortRobotByTeam(tabRobotId)
	rep=[]
	robotTeamName=[]
	if tabRobotId != nil
		for i in 0 .. (tabRobotId.size-1)
			if  Robot.find_by_id(tabRobotId[i]) != nil
				robotTeamName << Team.find_by_id(Robot.find_by_id(tabRobotId[i]).team_id).name
			end
		end
		robotTeamNameSort=robotTeamName.sort
		robotTeamNameSort= robotTeamNameSort.uniq
		for i in 0 .. (robotTeamNameSort.size-1)
			idTeam = Team.find_by_name(robotTeamNameSort[i]).id
			if Robot.where(team_id: idTeam) != nil
				rep = rep + sortRobotByName(Robot.where(team_id: idTeam).ids)
			end
		end
		arf= rep - tabRobotId

		rep= rep - arf
	end
	return rep
  end

   def sortMissionByName(tabMissionId)
	rep=[]
	missionNames=[]
	allMissionId=tabMissionId 
	if allMissionId != nil
		for i in 0 .. (allMissionId.size-1)
			if  Mission.find_by_id(allMissionId[i]) != nil
				missionNames << Mission.find_by_id(allMissionId[i]).name
			end
		end
		missionNamesSort=missionNames.sort
		for i in 0 .. (missionNamesSort.size-1)
			rep << Mission.find_by_name(missionNamesSort[i]).id 
		end
	end
	return rep
  end

=begin  
     def sortMissionByType(tabMissionId)
	rep=[]
	officialMission=[]
	customMission=[]
	allMissionId=tabMissionId 
	if allMissionId != nil
		for i in 0 .. (allMissionId.size-1)
			if  Mission.find_by_id(allMissionId[i]) != nil
				if Mission.find_by_id(allMissionId[i]).team_id == nil
					officialMission<<Mission.find_by_id(allMissionId[i]).id
				else
					customMission<<Mission.find_by_id(allMissionId[i]).id
				end
			end
		end
		officialMissionSort=sortMissionByName(officialMission)
		customMissionSort=sortMissionByName(customMission)
		rep=officialMissionSort+customMissionSort
	end
	return rep
  end
=end 
    def sortAttemptByTeam(tabAttemptId)
	idsTeam=Team.ids
	idsTeam=sortTeamByName(idsTeam)
	repc=Array.new(idsTeam.length,[])
	repnil=[]
	for i in tabAttemptId
		attem=Attempt.find_by_id(i)
		if attem != nil
			rob=Robot.find_by_id(attem.robot_id)
			if  rob!= nil
				indexId=idsTeam.index(rob.team_id)
				if indexId != nil
					repc[indexId]=repc[indexId]+[i]
				else
					repnil=repnil+[i]
				end
			end
		end
	end
	rep=repnil+repc.flatten!
	return rep
  end  

  def sortAttemptByRobot(tabAttemptId)
	idsRobots=Robot.ids
	idsRobots=sortRobotByName(idsRobots)
	repc=Array.new(idsRobots.length,[])
	for i in tabAttemptId
		arf=Attempt.find_by_id(i)
		if arf != nil
			indexId=idsRobots.index(arf.robot_id)
			if indexId != nil
				repc[indexId]=repc[indexId]+[i]
			end
		end
	end
	rep=repc.flatten!
	return rep
  end
  
  def sortAttemptByMission(tabAttemptId)
	idsMissions=Mission.ids
	idsMissions=sortMissionByName(idsMissions)
	repc=Array.new(idsMissions.length,[])
	for i in tabAttemptId
		arf=Attempt.find_by_id(i)
		if arf != nil
			indexId=idsMissions.index(arf.mission_id)
			if indexId != nil
				repc[indexId]=repc[indexId]+[i]
			end
		end
	end
	rep=repc.flatten!
	return rep
  end
  
  def sortAttemptByName(tabAttemptId)
	rep=[]
	allName=[]
	if tabAttemptId != nil
		for i in 0 .. (tabAttemptId.size-1)
			if  Attempt.find_by_id(tabAttemptId[i]) != nil
				allName << Attempt.find_by_id(tabAttemptId[i]).name
			end
		end
		namesSort=allName.sort
		
		for i in 0 .. (namesSort.size-1)
			rep << tabAttemptId[allName.index(namesSort[i])]
		end
	end	
	return rep
  end

   def sortAttemptByTracker(tabAttemptId)
	idsTrackers=Tracker.ids
	idsTrackers=sortTrackerByName(idsTrackers)
	repc=Array.new(idsTrackers.length,[])
	for i in tabAttemptId
		arf=Attempt.find_by_id(i)
		if arf != nil
			indexId=idsTrackers.index(arf.tracker_id)
			if indexId != nil
				repc[indexId]=repc[indexId]+[i]
			end
		end
	end
	rep=repc.flatten!
	return rep
  end

  def sortTrackerByName(tabTrackerId)
  	rep=[]
	allTrack=[]
	if tabTrackerId != nil
		for i in 0 .. (tabTrackerId.size-1)
			if  Tracker.find_by_id(tabTrackerId[i]) != nil
				allTrack << Tracker.find_by_id(tabTrackerId[i]).id
			end
		end
		namesSort=allTrack.sort
		
		for i in 0 .. (namesSort.size-1)
			rep << tabTrackerId[allTrack.index(namesSort[i])]
		end
	end	
	return rep
  end

 # function not working, coming back to it later
 # def sortTeamByLeaderName(tabTeamId)
	# rep=[]
	# teamNames=[]
	# teamLeaderNames=[]
	# allTeamsId=tabTeamId 
	# if allTeamsId != nil
	# 	for i in 0 .. (allTeamsId.size-1)
	# 		if  (Team.find_by_id(allTeamsId[i]) != nil && Member.find_by(Team.find_by_id(allTeamsId[i]).leader_id) != nil)
	# 			teamLeaderNames << Member.find_by(Team.find_by_id(allTeamsId[i]).leader_id).name
	# 		end
	# 	end
	# 	teamLeaderNamesSort=teamLeaderNames.sort
	# 	for i in 0 .. (teamLeaderNamesSort.size-1)
	# 		rep << Team.find_by_leader_id(Member.find_by_name(teamLeaderNamesSort[i]).id).id 
	# 	end
	# end
	# return rep
 #  end
 
=begin 
    def sortTriesTeam(tabTryId)
	idsTeam=Team.ids
	idsTeam=sortTeamByName(idsTeam)
	repc=Array.new(idsTeam.length,[])
	repnil=[]
	for i in tabTryId
		arf=Try.find_by_id(i)
		if arf != nil
			arf2=Robot.find_by_id(arf.robot_id)
			if  arf2!= nil
				indexId=idsTeam.index(arf2.team_id)
				if indexId != nil
					repc[indexId]=repc[indexId]+[i]
				else
					repnil=repnil+[i]
				end
			end
		end
	end
	repc.delete([])
	return repc
  end
  
  
  def sortTriesRobot(tabTryId)
	idsRobots=Robot.ids
	idsRobots=sortRobotByName(idsRobots)
	repc=Array.new(idsRobots.length,[])
	for i in tabTryId
		arf=Try.find_by_id(i)
		if arf != nil
			indexId=idsRobots.index(arf.robot_id)
			if indexId != nil
				repc[indexId]=repc[indexId]+[i]
			end
		end
	end
	repc.delete([])
	return repc
  end
  
  def sortTriesMission(tabTryId)
	idsMissions=Mission.ids
	idsMissions=sortMissionByName(idsMissions)
	repc=Array.new(idsMissions.length,[])
	for i in tabTryId
		arf=Try.find_by_id(i)
		if arf != nil
			indexId=idsMissions.index(arf.mission_id)
			if indexId != nil
				repc[indexId]=repc[indexId]+[i]
			end
		end
	end
	repc.delete([])
	return repc
  end
  
  def sortTRIES(tabTryId)
    rep=[]
    if tabTryId != nil
		arf1=sortTriesTeam(tabTryId)
		for i in arf1
			if i!=nil && i!=[]
				arf2=sortTriesRobot(i)
				for j in arf2
					if j != nil && j != []
						arf3=sortTriesMission(j)
						for k in arf3
							if k!=nil && k!=[]
								rep=rep+sortTryByName(k)
							end
						end
					end
				end
			end
		end
	end
	return rep
  end


=end
end
