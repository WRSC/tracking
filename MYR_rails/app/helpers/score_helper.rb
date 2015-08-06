module ScoreHelper
#argument is attempt_id
  def triangularTimecost(a_id)
  end
#===================================== Station Keeping ==================================================
  def stationKeepingTimecost(a_id)
    a=Attempt.find_by(a_id)
    # find all markers for this mission
    markers=Marker.where(mission_id: a.mission.id).order('id')
    # sort all coordiantes based on time
    testCoords=a.coordinates.order('datetime')
    stationKeepingTimecostWithData(markers,testCoords)
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
      jy=p[j].latitude.to_f
      jx=p[j].longitude.to_f
      y=p[i].latitude.to_f
      x=p[i].longitude.to_f
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
end
