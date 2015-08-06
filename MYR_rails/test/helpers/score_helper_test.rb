require 'test_helper'

  include ScoreHelper

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
  
  test "test many points in a circle should be out of the polygon" do 
    assert @p.length==4, "polygon is incorrect"
    for i in 0..50
      lat=5*Math::sin(i)+2.5
      lng=5*Math::cos(i)+2.5
      testP=Coordinate.create!( latitude:lat, longitude:lng, datetime:'20150225153927', tracker_id:1 )
      assert pInPolygon(testP,@p)==-1, "=========== !!! Error with point out polygon test =========== and pInPolygon return #{pInPolygon(testP,@p)}"
    end
  end 

  test "test many points in a circle should be in or on the polygon" do 
    assert @p.length==4, "polygon is incorrect"
    for i in 0..50
      lat=2.5*Math::sin(i)+2.5
      lng=2.4*Math::cos(i)+2.5
      testP=Coordinate.create!( latitude:lat, longitude:lng, datetime:'20150225153927', tracker_id:1 )
      assert pInPolygon(testP,@p)>=0, "=========== !!! Error with point out polygon test =========== and pInPolygon return #{pInPolygon(testP,@p)}"
    end
  end 

#======================= test stationkeeping timecost =====================
  test "test calculating stationkeeping timecost should near to 300" do
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
 #   assert false, "error with timecost and return coord is : lat is #{coords[res].latitude}, lng is #{coords[res].longitude}"
    assert ( res >=298 and res <= 302), "error with timecost and return #{res}"
  end
end
