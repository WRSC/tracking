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


end
