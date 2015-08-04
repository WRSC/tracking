module ScoreHelper
#argument is attempt_id
  def triangularTimecost(a_id)
  end
  
  def stationKeepingTimecost(a_id)
    a=Attempt.find_by(a_id)
    # find all markers for this mission
    markers=Marker.where(mission_id: a.mission.id).order('id')
    # sort all coordiantes based on time
    testCoords=a.coordinates.order('datetime')
    # begin to calculate the score
  end

  #http://alienryderflex.com/polygon/
  #0=> on the polygon  1 => in the polygon  -1 => out of the polygon
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
end
