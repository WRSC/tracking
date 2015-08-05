require 'test_helper'

  include ScoreHelper

class ScoreHelperTest < ActionView::TestCase
  test "should in the polygon" do
    p=[]
    p.push(markers(:m1))
    p.push(markers(:m2)) 
    p.push(markers(:m3)) 
    p.push(markers(:m4))
    assert p.length==4
    testP1=coordinates(:testOutP)
    assert testP1.datetime=='20150225153926'
    assert pInPolygon(testP1,p)==-1
    testP2=coordinates(:testInP)
    assert testP2.datetime=='20150225153927'
    assert pInPolygon(testP2,p)==1
  end

end
