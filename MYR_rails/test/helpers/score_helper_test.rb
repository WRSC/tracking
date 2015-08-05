require 'test_helper'

  include ScoreHelper

class ScoreHelperTest < ActionView::TestCase
   test "should out the polygon" do
    p=[]
    p.push(markers(:m1))
    p.push(markers(:m2)) 
    p.push(markers(:m3)) 
    p.push(markers(:m4))
    assert p.length==4
    testP=coordinates(:testOutP)
    assert testP.datetime=='20150225153926'
    assert pInPolygon(testP,p)==-1, "=========== !!! Error with point out polygon test =========== and pInPolygon return #{pInPolygon(testP,p)}"
   end

  test "testP should be in the polygon" do
    p=[]
    p.push(markers(:m1))
    p.push(markers(:m2)) 
    p.push(markers(:m3)) 
    p.push(markers(:m4))
    assert p.length==4
    testP=coordinates(:testInP)
    assert testP.datetime=='20150225153927'
    assert pInPolygon(testP,p)==1, "========== !!! Error with point in polygon test========== and pInPolygon return #{pInPolygon(testP,p)}"
  end


end
