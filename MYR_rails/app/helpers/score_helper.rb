require 'fileutils'

module ScoreHelper

#if timecost==-1 => no coordinates
#if timecost==-2 => no markers || one of marker necessary did not exisit 
#if timecost==-3 => there are some markers but marker format incorrect
	def getTimecostbyAttemptId(a_id)
		
		a=Attempt.find_by_id(a_id)
		t=-100
		if a==nil
			return "attempt does not exist"
		else
			case a.mission.mtype
			when  "TriangularCourse"
				t=getTimeTriangularCourse(a)
			when "StationKeeping"
				t=stationKeepingTimecost(a_id)
			when "AreaScanning"
				
			when "Race"
				t=getTimeRaceCourse(a)
			end
		end
	
		return t
	end


#========================= Fleet Race  =============================
    def checkLineCrossed(myLine,coordinates)
      # résolution paramétrique
      # caracteristiques de la ligne
      line = myLine
      l1 = [line[0][0].to_f,line[1][0].to_f] # extrémité 1 A => l1[0] : Ax, l1[1] : Ay
      l2 = [line[0][1].to_f,line[1][1].to_f] # extrémité 2 B
      vl = [l2[0]-l1[0],l2[1]-l1[1]] # vecteur l1l2 I => vl[0] : Ix, vl[1] : Iy

      #iterer les coordonnées pour savoir si on passe la ligne

      c1 = [0.0,0.0]
      c2 = [0.0,0.0]
      vc = [0.0,0.0]

      time = 0

      intersec = false;
      i = 0
      while (i < coordinates.length-1)&&(!intersec)
        c1 = [coordinates[i].longitude.to_f,coordinates[i].latitude.to_f] # C => c1[0] : Cx, c1[1] : Cy
        c2 = [coordinates[i+1].longitude.to_f,coordinates[i+1].latitude.to_f] #D
        vc = [c2[0]-c1[0],c2[1]-c1[1]] # J  => vc[0] : Jx, vc[1] : Jy


        cond1 = vl[0]*vc[1]-vl[1]*vc[0] # condition de non parallélisme : si = 0 => segments parallèles
        if (cond1 != 0)
          m = ( -vl[0]*c1[1]+vl[0]*l1[1] - vl[1]*l1[0]+vl[1]*c1[0] )/cond1;
          k = ( -vc[0]*c1[1]+vc[0]*l1[1] - vc[1]*l1[0]+vc[1]*c1[0] )/cond1;
          if ((m<=1)&&(m>=0)&&(k<=1)&&(k>=0))
            intersec=true
            time = coordinates[i+1].datetime.to_f
          end
        end
        i = i + 1
      end

      return time

    end

    def checkRoundBuoy(myLine,buoy,coordinates,order)
      # 4 sectors around the buoy limited by lines, if the boat crossed all of them in a logic order it is validated

      line = myLine
      lineV = [line[0][1].to_f-line[0][0].to_f,line[1][1].to_f-line[1][0].to_f]
      pointN = [buoy[0].to_f+lineV[0],buoy[1].to_f+lineV[1]]
      pointS = [buoy[0].to_f-lineV[0],buoy[1].to_f-lineV[1]]
      pointW = [buoy[0].to_f-lineV[1],buoy[1].to_f+lineV[0]]
      pointE = [buoy[0].to_f+lineV[1],buoy[1].to_f-lineV[0]]
      lineN = [[buoy[0].to_f,pointN[0]],[buoy[1].to_f,pointN[1]]]
      lineS = [[buoy[0].to_f,pointS[0]],[buoy[1].to_f,pointS[1]]]
      lineW = [[buoy[0].to_f,pointW[0]],[buoy[1].to_f,pointW[1]]]
      lineE = [[buoy[0].to_f,pointE[0]],[buoy[1].to_f,pointE[1]]]

      time = 0

      tN = 0
      tS = 0
      tW = 0
      tE = 0

      if (order.include? "N")
        tN = checkLineCrossed(lineN,coordinates)
      end
      if (order.include? "S")
        tS = checkLineCrossed(lineS,coordinates)
      end
      if (order.include? "W")
        tW = checkLineCrossed(lineW,coordinates)
      end
      if (order.include? "E")
        tE = checkLineCrossed(lineE,coordinates)
      end

      #if (((tN != 0)||(!order.include? "N"))&&((tE != 0)||(!order.include? "E"))&&((tW != 0)||(!order.include? "W"))&&((tS != 0)||(!order.include? "S"))) 
      time = [tN,tS,tW,tE].max
      #end

      return time

    end

    def getTimeTriangularCourse(attempt)
      mission_id = attempt.mission_id
      myTrackerID= attempt.tracker_id
      startTime = attempt.start.strftime('%Y%m%d%H%M%S')
      endTime = attempt.end.strftime('%Y%m%d%H%M%S')
      coordinates = Coordinate.where("datetime > ?", startTime).where("datetime < ?", endTime).where(tracker_id: myTrackerID).order(datetime: :asc)
#if there is not any coordinate return -1
			if coordinates.length <= 0
				return -1
			end

      # The markers should be created in this order : first => start line, second =>  end line, third => first buoy, fourth => second buoy
      sLine = Marker.where(mission_id: mission_id).find_by_name("startLine")
      eLine = Marker.where(mission_id: mission_id).find_by_name("endLine")
      myFirstBuoy = Marker.where(mission_id: mission_id).find_by_name("firstBuoy")
      mySecondBuoy = Marker.where(mission_id: mission_id).find_by_name("secondBuoy")
			if sLine==nil || eLine==nil || myFirstBuoy==nil || mySecondBuoy==nil
				return -2
			end

     # mise en forme des lignes


      startLine = []
      startLine << sLine.longitude.split("_")
      startLine << sLine.latitude.split("_")
      endLine = []
      endLine << eLine.longitude.split("_")
      endLine << eLine.latitude.split("_")

      # fin mise en forme des lignes

      # mise en forme des buoys

      firstBuoy = []
      secondBuoy = []
      firstBuoy.push(myFirstBuoy.longitude)
      firstBuoy.push(myFirstBuoy.latitude)
      secondBuoy.push(mySecondBuoy.longitude)
      secondBuoy.push(mySecondBuoy.latitude)

      # fin mise en forme des buyos

      tSL = 0
      tEL = 0
      tSB = 0
      tFB = 0
      time = 0

      tSL = checkLineCrossed(startLine,coordinates) # time for start line
			
      if tSL != 0
        coordinates = coordinates.where("datetime >= ?", tSL-1).order(datetime: :asc)

        tFB = checkRoundBuoy(endLine,firstBuoy,coordinates,"NSEW")
				
        if tFB != 0
          coordinates = coordinates.where("datetime >= ?", tFB-1).order(datetime: :asc)

          tSB = checkRoundBuoy(startLine,secondBuoy,coordinates,"NSEW")

          if tSB != 0
            coordinates = coordinates.where("datetime >= ?", tSB-1).order(datetime: :asc)

            tEL = checkLineCrossed(endLine, coordinates)
          end
        end
      end

      if tEL != 0
        time = timeDifference(tEL.to_s, tSL.to_s)
      end

      return time

    end

    def getTimeRaceCourse(attempt)
      mission_id = attempt.mission_id
      myTrackerID= attempt.tracker_id
      startTime = attempt.start.strftime('%Y%m%d%H%M%S')
      endTime = attempt.end.strftime('%Y%m%d%H%M%S')
      globalStartTime = Mission.find(mission_id).startOfRace
      coordinates = (Coordinate.where(id: Coordinate.where("datetime > ?", startTime).where("datetime < ?", endTime).where(tracker_id: myTrackerID).order(datetime: :asc))).where("datetime > ?", startTime).where("datetime < ?", endTime).where(tracker_id: myTrackerID).select(:datetime,:latitude,:longitude).order(datetime: :asc)
			if coordinates.length <=0 
				return -1
			end
      # The markers should be created in this order : first => start line (first point of the start line = first Buoy), second => first Buoy, third => second Buoy, fourth => third Buoy, fifth => fourth Buoy

      sLine = Marker.where(mission_id: mission_id).find_by_name("startLine")
      firstCorner = Marker.where(mission_id: mission_id).find_by_name("firstBuoy") # order
      secondCorner = Marker.where(mission_id: mission_id).find_by_name("secondBuoy") # order
      thirdCorner = Marker.where(mission_id: mission_id).find_by_name("thirdBuoy") # order
      fourthCorner = Marker.where(mission_id: mission_id).find_by_name("fourthBuoy") # order

			if sLine==nil || firstCorner==nil || secondCorner==nil || thirdCorner==nil || fourthCorner==nil
				return -2
			end
      startLine = []
      startLine << sLine.longitude.split("_")
      startLine << sLine.latitude.split("_")     
      firstBuoy = []
      secondBuoy = []
      thirdBuoy = []
      fourthBuoy = []
      firstBuoy.push(firstCorner.longitude)
      firstBuoy.push(firstCorner.latitude)
      secondBuoy.push(secondCorner.longitude)
      secondBuoy.push(secondCorner.latitude)
      thirdBuoy.push(thirdCorner.longitude)
      thirdBuoy.push(thirdCorner.latitude)
      fourthBuoy.push(fourthCorner.longitude)
      fourthBuoy.push(fourthCorner.latitude)

      time = -1 #Time = -1 => the boat did not even cross the starting line, # Time = 0 the boat crossed the starting line
      turn = 0

      if (checkLineCrossed(startLine,coordinates)!=0)
        time = 0;
      end

      for i in 1..2
        tFiB = 0
        tSeB = 0
        tThB = 0
        tFoB = 0

        tSeB = checkRoundBuoy(startLine, secondBuoy, coordinates, "NW")
        

        if (tSeB != 0)
          coordinates = coordinates.where("datetime >= ?", tSeB-1).order(datetime: :asc)
          tThB = checkRoundBuoy(startLine, thirdBuoy, coordinates, "WS")
          

          if (tThB != 0)
            coordinates = coordinates.where("datetime >= ?", tThB-1).order(datetime: :asc)
            tFoB = checkRoundBuoy(startLine, fourthBuoy, coordinates, "SE")
            

            if (tFoB != 0)
              coordinates = coordinates.where("datetime >= ?", tFoB-1).order(datetime: :asc)
              tFiB = checkRoundBuoy(startLine, firstBuoy, coordinates, "EN")

              if tFiB != 0
                coordinates = coordinates.where("datetime >= ?", tFiB-1).order(datetime: :asc)
                turn = turn+1
                if turn == 2
                  time = timeDifference(tFiB.to_s, globalStartTime.to_s)
                end
              end
            end
          end
        end
      end
      return time
    end

    def timeDifference(t1,t2) # calculates t1-t2, both formated as %Y%m%d%H%M%S
      temp1 = DateTime.strptime(t1,'%Y%m%d%H%M%S').to_time
      temp2 = DateTime.strptime(t2,'%Y%m%d%H%M%S').to_time
      res = temp1 - temp2
      return res
    end

#================================= Station Keeping ==============================================
  def stationKeepingRawScore(a_id)
    timecost=stationKeepingTimecost(a_id)
    return stationKeepingRawScoreWithTimecost(timecost)
  end

  def stationKeepingRawScoreWithTimecost(timecost)
    ans=10-(300-timecost).abs*1.0/10
    return 0.0 > ans ? 0.0 : ans
  end

  def stationKeepingTimecost(a_id)
    a=Attempt.find_by_id(a_id)
    # find all markers for this mission
    poly=Marker.where(mission_id: a.mission.id).where(name: "Station Keeping Zone")
		# poly.size <=0 did not create markers
		# poly.size >0 more than one marker
		if poly.size!=1
			return -2
		end
		tablat=poly[0].latitude.split("_")
		tablng=poly[0].longitude.split("_")
		markers=[]
		for i in 0..(tablat.length-1)
			if tablat[i]!="" and tablng[i]!="" and tablat[i] and tablng[i]
				markers.push({:latitude => tablat[i], :longitude => tablng[i]})
			end
		end
    # sort all coordiantes based on time
		mission_id = a.mission.id
    myTrackerID= a.tracker_id
    startTime = a.start.strftime('%Y%m%d%H%M%S')
    endTime = a.end.strftime('%Y%m%d%H%M%S')
    coordinates = (Coordinate.where(id: Coordinate.where("datetime > ?", startTime).where("datetime < ?", endTime).where(tracker_id: myTrackerID).order(datetime: :asc))).where("datetime > ?", startTime).where("datetime < ?", endTime).where(tracker_id: myTrackerID).select(:datetime,:latitude,:longitude).order(datetime: :asc)
    testCoords=a.coordinates.order('datetime')
		#if there is not any coordinates return -1		
		if testCoords.length <= 0
			return -1
		end 
    timecost=stationKeepingTimecostWithData(markers,testCoords)
    return timecost
  end
  
  def stationKeepingTimecostWithData(markers,testCoords)
    # begin to calculate the score
    i=0
    # At the begining , it should be out of polygon zone
    while (pInPolygon(testCoords[i], markers) > 0)
      i+=1
    end
    outflag=true
    
    while (pInPolygon(testCoords[i], markers) < 0 )
      i+=1
    end
    # starting to count the time
    outflag=false
    tstart=testCoords[i].datetime
    lastDatetime=testCoords[i].datetime
    i+=1
    warnflag=false
    twarn=0
    v=-1
    while (outflag==false)
      inp=pInPolygon(testCoords[i],markers)
      if (inp < 0)
        warnflag=true
        twarn+= datetimeAMinusB(testCoords[i].datetime,lastDatetime)
      else
        if warnflag==true
          warnflag=false
          twarn=0
        end
      end
  
      if (warnflag==true)
        if (twarn >= 10)
          tend=testCoords[i].datetime
          v=i
          outflag=true
        end
      end
      lastDatetime=testCoords[i].datetime
      i+=1
    end
    # there is always an error with 10s, when the boat wants to go out, the 10s was ignored
    return datetimeAMinusB(tend,tstart)-10
  end

  #http://alienryderflex.com/polygon/
  #0=> on the polygon  1 => in the polygon  -1 => out of the polygon
  #dp=desired point    p = polygon
  def pInPolygon(dp,p)
    #return p[3].latitude
    #return p[3].longitude
    j=p.length-1
    count=0 # count is the number of oddNodes
    # add the first coordinate to the polygon 
    p_y=dp.latitude.to_f
    p_x=dp.longitude.to_f
    for i in 0..(p.length-1)
      jy=p[j][:latitude].to_f
      jx=p[j][:longitude].to_f
      y=p[i][:latitude].to_f
      x=p[i][:longitude].to_f
      # if is one of the vertex in polygon
      if (y==p_y and x==p_x or jy==p_y and jx=p_x)
        return 0
      end
      if ( (y < p_y and jy >= p_y) or (jy < p_y and y >= p_y)) and  (x <= p_x or jx <= p_x)
          # the order of points of the  polygon is important, in this case is in clockwise or anti-clockwise
        lx=x + (p_y-y)/(jy-y)*(jx-x)
        if (lx==p_x)
          return 0
        end

        if (lx < p_x)
          count+=1
        end
      end
      j=i
    end
    if count % 2 == 0
      return -1
    else
      return 1
    end 
  end
  
#here a,b are string which refer to yyyymmddhhmmss
#Subtracting two DateTimes returns the elapsed time in days
  def datetimeAMinusB(a,b)
    return ((a.to_datetime-b.to_datetime)*24*60*60).to_i
  end
#========================= Area scanning ===========================
  def AminusB(a,b)
		return a.to_i-b.to_i	
	end


=begin
http://www.movable-type.co.uk/scripts/latlong.html
	var R = 6371000; // metres
	var φ1 = lat1.toRadians();
	var φ2 = lat2.toRadians();
	var Δφ = (lat2-lat1).toRadians();
	var Δλ = (lon2-lon1).toRadians();

	var a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
		      Math.cos(φ1) * Math.cos(φ2) *
		      Math.sin(Δλ/2) * Math.sin(Δλ/2);
	var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

	var d = R * c;	
=end
	def d_to_m(s_lat_d,s_lng_d,d_lat_d,d_lng_d)
		r = 6371000
		s_lat_r=s_lat_d.to_f*Math::PI/180
		d_lat_r=d_lat_d.to_f*Math::PI/180
		delta_lat=d_lat_r-s_lat_r
		delta_lng=(d_lng_d.to_f-s_lng_d.to_f)*Math::PI/180
		a= Math.sin(delta_lat/2) * Math.sin(delta_lat/2) +Math.cos(s_lat_r) * Math.cos(d_lat_r) *Math.sin(delta_lng/2) * Math.sin(delta_lng/2);
		c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
		d = r * c
		return d
	end
	

# enable download some files for users
#http://stackoverflow.com/questions/13164063/file-download-link-in-rails 
 #here the json data files are in rails.root/public/uploads/scores/areascanning/nameoffile.json
  def loadJsonDataAreaScanning(inputname)
  #need to check filename if it was json file
    filename = File.join(Rails.root, 'public','uploads', 'scores','areascanning','origin', inputname) 
    f=File.read(filename) 
    f_hash = JSON.parse(f) 
		d_hash=calculateMaxDistance(f_hash)
    done=generateJsonFile(d_hash)
    return done
  end
  
	def calculateMaxDistance(f_hash)
		d_hash=Hash.new #the desired hash which contains the result of comparison
		d_hash['name']=f_hash['name']
		d_hash['explanation']="All the differences from trackers to team's coordinates are in absolute values with unity meter"
		datas=[]
		data_length=f_hash['data'].length
		max_d=-1
		for i in 0..(data_length-1)
			section_hash=Hash.new
			section_hash['sectioni']=f_hash['data'][i]['sectioni']
			section_hash['sectionj']=f_hash['data'][i]['sectionj']
			position = f_hash['data'][i]['position']
			position_length=position.length
			positions=[]
			max_dis=-1
      tracker_err_count=0
			for k in 0..(position_length-1)
				coord = Coordinate.where(datetime: position[k]['datetime'])
				p_hash=Hash.new
				p_hash['datetime']=position[k]['datetime']
        #p_hash['tracker_coords_length']=coord.size
				if coord.size != 1
				# if there is any data in the tracker		
          tracker_err_count+=1
					p_hash['difference_from_tracker_to_team']= 'tracker error'
				else
					dis=d_to_m(position[k]['latitude'],position[k]['longitude'],coord[0].latitude,coord[0].longitude)
					p_hash['difference_from_tracker_to_team']=dis
					dis > max_dis ? max_dis=dis : max_dis=max_dis
				end
				positions.push(p_hash)
			end
			section_hash['geo-position-checking']=positions
      if tracker_err_count != positions.length
			  section_hash['Section-Max_difference_from_tracker_to_team']=max_dis
      else
			  section_hash['Section-Max_difference_from_tracker_to_team']="tracker error"
      end
			datas.push(section_hash)
			max_d > max_dis ? max_d=max_d : max_d = max_dis
		end
		d_hash['data']=datas
		if max_d != -1
			d_hash['Max_distance_from_all_sections']=max_d
		else
			d_hash['Max_distance_from_all_sections']="tracker error"
		end
		return d_hash	
	end

#some options for output files
#json file object.to_json
#yaml file object.to_yaml
#xml  file object.to_xml 

  def generateJsonFile(f_hash)
    outputname=f_hash['name']+'_generated_'+Time.now.to_s+'.xml'
    directory = File.join(Rails.root, 'public','uploads', 'scores','areascanning', 'generated')
    FileUtils::mkdir_p directory
    filename = File.join(directory, outputname)
    #saveOutputnameToattempt(filename,a)
    File.open(filename,"w") do |f|
      f.write(f_hash.to_xml)
    end
    #return File.exist?(filename)
		return filename
  end

	def saveOutputnameToattempt(filename,attempt)
		attempt.update_attribute(:generated_filename, filename) 
	end

#================== sort by finalscore ==============
	def getRank(roblist)
		for i in 0..(roblist.length-1)
			for j in i..(roblist.length-1)
				if roblist[i].finalscore < roblist[j].finalscore
					tmp=  roblist[j]
					roblist[j]= roblist[i]
					roblist[i]= tmp		
				end 			
			end	
		end
		rank=1
		i=0
		repeat=1
		while i< roblist.length
			if i!=roblist.length-1
				if roblist[i].finalscore==roblist[i+1].finalscore
					roblist[i].update_attribute(:finalrank, rank)
					repeat+=1
					i+=1
				else
					roblist[i].update_attribute(:finalrank, rank)
					if repeat==1
						rank+=1
					else
						rank+=repeat
					end
					i+=1
					repeat=1
				end
			else
				roblist[i].update_attribute(:finalrank, rank)
				i+=1
			end		

		end
		return roblist
	end

end
