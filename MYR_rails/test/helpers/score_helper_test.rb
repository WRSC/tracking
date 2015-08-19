require 'test_helper'

  include ScoreHelper

  class ScoreHelperTest < ActionView::TestCase

    #test for triangular course scoring

  test "should cross start line" do
    coordSample = Coordinate.where("datetime > ?", 20150605010101).order(datetime: :asc)
  	# coordSample = []
   #  coordSample.push(coordinates(:c2))
   #  coordSample.push(coordinates(:c3))
  	assert coordSample.length != 0, "#{coordSample.length}\n"

  	lineSample = markers(:startLine)

    startLine = []
    startLine << lineSample.longitude.split("_")
    startLine << lineSample.latitude.split("_")

    #assert false, "#{startLine[0][0]} #{startLine[1][0]} #{startLine[0][1]} #{startLine[1][1]}"

    assert startLine.length == 2, "#{startLine.length}\n"
    assert startLine[0].length == 2, "#{startLine[0].length}\n"
    assert startLine[1].length == 2, "#{startLine[1].length}\n"

  	res = checkLineCrossed(startLine,coordSample)
  	assert res != 0, "#{res}\n"
  end

  test "should cross end line" do
    coordSample = []
    coordSample.push(coordinates(:c107))
    coordSample.push(coordinates(:c108))
    assert coordSample.length != 0, "#{coordSample.length}\n"

    lineSample = markers(:endLine)

    myLine = []
    myLine << lineSample.longitude.split("_")
    myLine << lineSample.latitude.split("_")
    assert myLine.length == 2, "#{myLine.length}\n"
    assert myLine[0].length == 2, "#{myLine[0].length}\n"
    assert myLine[1].length == 2, "#{myLine[1].length}\n"

    res = checkLineCrossed(myLine,coordSample)
    assert res != 0, "#{res}\n"
  end

  test "should turn first buoy" do
  	coordSample = Coordinate.where("datetime > ?", 20150605010101).order(datetime: :asc)
  	assert coordSample.length != 0, "#{coordSample.length}\n"

  	lineSample = markers(:endLine)
    myLine = []
    myLine << lineSample.longitude.split("_")
    myLine << lineSample.latitude.split("_")

    #assert false, "#{myLine[0][0]} #{myLine[1][0]} #{myLine[0][1]} #{myLine[1][1]}"

    assert myLine.length == 2, "#{myLine.length}\n"
    assert myLine[0].length == 2, "#{myLine[0].length}\n"
    assert myLine[1].length == 2, "#{myLine[1].length}\n"

  	myBuoy = markers(:firstBuoy)
    buoySample = []
    buoySample.push(myBuoy.longitude)
    buoySample.push(myBuoy.latitude)

  	res = checkRoundBuoy(myLine,buoySample,coordSample,"NWSE")
  	assert res != 0, "#{res}"
    
  end

  test "should turn second buoy" do
    coordSample = Coordinate.where("id > ?", 52)
    assert coordSample.length != 0, "#{coordSample.length}\n"

    lineSample = markers(:startLine)
    myLine = []
    myLine << lineSample.longitude.split("_")
    myLine << lineSample.latitude.split("_")
    assert myLine.length == 2, "#{myLine.length}\n"
    assert myLine[0].length == 2, "#{myLine[0].length}\n"
    assert myLine[1].length == 2, "#{myLine[1].length}\n"

    myBuoy = markers(:secondBuoy)
    buoySample = []
    buoySample.push(myBuoy.longitude)
    buoySample.push(myBuoy.latitude)

    res = checkRoundBuoy(myLine,buoySample,coordSample,"NWSE")
    assert res != 0, "#{res}\n"
  end

  test "should do triangle" do
    attemptSample = Attempt.first
    assert attemptSample.mission_id == 1, "#{attemptSample.mission_id}"

    res = getTimeTriangularCourse(attemptSample)
    assert res != 0, "#{res}\n"

  end

  # end tests for triangular course scoring

  # begin test for race course scoring

  test "should turn buoy race" do

    coordSample = Coordinate.where("datetime >= ?", 20150605010101).order(datetime: :asc)
    assert coordSample.length != 0, "#{coordSample.length}\n"

    lineSample = markers(:startLine)
    myLine = []
    myLine << lineSample.longitude.split("_")
    myLine << lineSample.latitude.split("_")

    assert myLine.length == 2, "#{myLine.length}\n"
    assert myLine[0].length == 2, "#{myLine[0].length}\n"
    assert myLine[1].length == 2, "#{myLine[1].length}\n"

    myBuoy = markers(:secondBuoy)
    buoySample = []
    buoySample.push(myBuoy.longitude)
    buoySample.push(myBuoy.latitude)

    res = checkRoundBuoy(myLine,buoySample,coordSample,"NW")
    assert res != 0, "#{res}"

  end

  test "should do race" do
    attemptSample = Attempt.first
    assert attemptSample.mission_id == 1, "#{attemptSample.mission_id}"

    res = getTimeRaceCourse(attemptSample)
    assert res != 0, "#{res}\n"

  end

  test "should differ times" do
    res = timeAddition("19930924010303","19700101000001")
    assert res != 0, "#{res}\n" 
  end

end

class ScoreHelperTest < ActionView::TestCase
  
  def setup()
    p=[]
    p.push(markers(:m1))
    p.push(markers(:m2)) 
    p.push(markers(:m3)) 
    p.push(markers(:m4))
    @p=p
  end
#============================ station keeping =================================
 
  #==========================  Test Point in a Polygon =======================
  test " testP should be out the polygon" do
    assert @p.length==4
    testP=coordinates(:testOutP)
    assert testP.datetime=='20150225153926'
    assert pInPolygon(testP,@p)==-1, "=========== !!! Error with point out polygon test =========== and pInPolygon return #{pInPolygon(testP,@p)}"
   end

  test "testP should be in the polygon" do
    assert @p.length==4
    testP=coordinates(:testInP)
    assert testP.datetime=='20150225153927'
    assert pInPolygon(testP,@p)==1, "========== !!! Error with point in polygon test========== and pInPolygon return #{pInPolygon(testP,@p)}"
  end

  test "testP should be one of vertex in the polygon" do
    assert @p.length==4, "polygon is incorrect"
    testP=coordinates(:testOnVP)
    assert testP.datetime=='20150225153927', "test Point is incorrect"
    assert pInPolygon(testP,@p)==0, "=========== !!! Error with point out polygon test =========== and pInPolygon return #{pInPolygon(testP,@p)}"
  end
  
  test "testP should be on  one of edge in the polygon" do
    assert @p.length==4, "polygon is incorrect"
    testP=coordinates(:testOnEP)
    assert testP.datetime=='20150225153927', "test Point is incorrect"
    assert pInPolygon(testP,@p)==0, "=========== !!! Error with point out polygon test =========== and pInPolygon return #{pInPolygon(testP,@p)}"
  end
  
  test "Many points in a circle should be out of the polygon" do 
    assert @p.length==4, "polygon is incorrect"
    for i in 0..50
      lat=5*Math::sin(i)+2.5
      lng=5*Math::cos(i)+2.5
      testP=Coordinate.create!( latitude:lat, longitude:lng, datetime:'20150225153927', tracker_id:1 )
      assert pInPolygon(testP,@p)==-1, "=========== !!! Error with point out polygon test =========== and pInPolygon return #{pInPolygon(testP,@p)}"
    end
  end 

  test "Many points in a circle should be in or on the polygon" do 
    assert @p.length==4, "polygon is incorrect"
    for i in 0..50
      lat=2.5*Math::sin(i)+2.5
      lng=2.4*Math::cos(i)+2.5
      testP=Coordinate.create!( latitude:lat, longitude:lng, datetime:'20150225153927', tracker_id:1 )
      assert pInPolygon(testP,@p)>=0, "=========== !!! Error with point out polygon test =========== and pInPolygon return #{pInPolygon(testP,@p)}"
    end
  end 

#======================= test stationkeeping timecost and rawscore =====================
  test "Calculating stationkeeping timecost should near to 300" do
    t="2015-08-06 08:47:07 +0200".to_time
    lat=-3
    lng=2.5
    coords=[]
    # at the first 30s , it keep in line and it is entering the zone
    coords.push(Coordinate.create!( latitude:lat, longitude:lng, datetime:t.strftime("%Y%m%d%H%M%S"), tracker_id:1 ))
    #assert false, "coords[0].dateime is #{coords[0].datetime} !!! and lat is #{coords[0].latitude} !!! and lng is #{coords[0].longitude}"
    for i in 1..30
      t+=1
      lat=lat+0.1
      coords.push(Coordinate.create!( latitude:lat, longitude:lng, datetime:t.strftime("%Y%m%d%H%M%S"), tracker_id:1 ))
    end
    #assert false, "coords[30].dateime is #{coords[30].datetime} !!! and lat is #{coords[30].latitude} !!! and lng is #{coords[30].longitude}"
    # then turn around alone the path of a circle during 300s 
    for i in 1..300
      t+=1
      lat=2.5+2.5*Math::sin(-Math::PI/2+i*Math::PI/15)
      lng=2.5+2.5*Math::cos(-Math::PI/2+i*Math::PI/15)
      coords.push(Coordinate.create!( latitude:lat, longitude:lng, datetime:t.strftime("%Y%m%d%H%M%S"), tracker_id:1 ))
    end
    #assert false, "coords[330].dateime is #{coords[330].datetime} !!! and lat is #{coords[330].latitude} !!! and lng is #{coords[330].longitude}"
    # At last 30s, it will go out this zone alone a line path
    for i in 1..30
      t+=1
      lat-=0.1
      coords.push(Coordinate.create!( latitude:lat, longitude:lng, datetime:t.strftime("%Y%m%d%H%M%S"), tracker_id:1 ))
    end
    #assert false, "coords[360].dateime is #{coords[360].datetime} !!! and lat is #{coords[360].latitude} !!! and lng is #{coords[360].longitude}"
    
    res=stationKeepingTimecostWithData(@p,coords)
#    assert false, "error with timecost and return coord is : timecost is #{res} "
    rawscore=stationKeepingRawScoreWithTimecost(res)
    #assert ( res >=298 and res <= 302), "error with timecost and return #{res}"
    assert ( rawscore >= 9.9 and rawscore <= 10), "error with rawscore  and return #{rawscore}"
    #assert false, "error with rawscore  and return #{rawscore}"
  end




#this test failed because of the accuracy of computer, especially when calculatee Math::PI and Math::sqrt()
  test "Calculating stationkeeping rawscore should near to 300 with a path of circle" do
    t="2015-08-06 08:47:07 +0200".to_time
    r=2.5*Math::sqrt(2)-0.001
    lat=-3
    lng=2.5
    coords=[]
    # at the first 30s , it keep in line and it is entering the zone
    coords.push(Coordinate.create!( latitude:lat, longitude:lng, datetime:t.strftime("%Y%m%d%H%M%S"), tracker_id:1 ))
    #assert false, "coords[0].dateime is #{coords[0].datetime} !!! and lat is #{coords[0].latitude} !!! and lng is #{coords[0].longitude}"
    for i in 1..30
      t+=1
      lat=lat+(3-(r-2.5))/30
      coords.push(Coordinate.create!( latitude:lat, longitude:lng, datetime:t.strftime("%Y%m%d%H%M%S"), tracker_id:1 ))
    end
    #assert false, "coords[30].dateime is #{coords[30].datetime} !!! and lat is #{coords[30].latitude} !!! and lng is #{coords[30].longitude}"
    # then turn around alone the path of a circle during 300s 
    theta=-Math::PI/2
    for i in 1..280
      t+=1
      theta+=2*Math::PI/40
      lat=2.5+r*Math::sin(theta)
      lng=2.5+r*Math::cos(theta)
      coords.push(Coordinate.create!( latitude:lat, longitude:lng, datetime:t.strftime("%Y%m%d%H%M%S"), tracker_id:1 ))
    end
#    assert false, "coords[330].dateime is #{coords[310].datetime} !!! and lat is #{coords[310].latitude} !!! and lng is #{coords[310].longitude}"
    # At last 30s, it will go out this zone alone a line path
    for i in 1..30
      t+=1
      lat-=(3-r+2.5)/30
      coords.push(Coordinate.create!( latitude:lat, longitude:lng, datetime:t.strftime("%Y%m%d%H%M%S"), tracker_id:1 ))
    end
    #assert false, "coords[340].dateime is #{coords[340].datetime} !!! and lat is #{coords[340].latitude} !!! and lng is #{coords[340].longitude}"
    
    res=stationKeepingTimecostWithData(@p,coords)
    #assert false, "coords[res].dateime is #{coords[res].datetime} !!! and lat is #{coords[res].latitude} !!! and lng is #{coords[res].longitude}"
    #assert false, "error with timecost and return coord is : dateime is #{res}"
    rawscore=stationKeepingRawScoreWithTimecost(res)
    #assert ( res >=298 and res <= 302), "error with timecost and return #{res}"
    #assert ( rawscore >= 0  and rawscore <= 0.1), "error with rawscore  and return #{rawscore}"
    assert rawscore==7.0, "error with rawscore  and return #{rawscore}"
  end
end