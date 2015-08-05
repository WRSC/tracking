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
          outflag=true
        end
      end
      lastDatetime=testCoords[i].datetime
      i+=1
    end
    return datetimeAMinusB(tstart,tend)
  end

  #http://alienryderflex.com/polygon/
  #0=> on the polygon  1 => in the polygon  -1 => out of the polygon
  #dp=desired point    p = polygon
  def pInPolygon(dp,p)
    j=p.length-1
    jy=p[j].latitude
    jx=p[j].longitude
    count=0 # count is the number of oddNodes
    # add the first coordinate to the polygon 
    for i in 0..(p.length-1)  
      y=p[i].latitude
      x=p[i].longitude
      # if is one of the vertex in polygon
      if (y==dp.latitude and x==dp.longitude || jy==dp.latitude and jx=dp.longitude)
        return 0
      end
      if ((y < dp.latitude and jy >= dp.latitude || jy < dp.latitude and y >= dp.latitude) and  (x <= dp.longitude || jx <= dp.longitude) )
          # the order of points of the  polygon is important, in this case is in clockwise or anti-clockwise
          lx=x + (dp.latitude-y)/(jy-y)*(jx-x)
          if (lx==dp.longitude)
            return 0
          end

          if (lx < dp.longitude)
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
