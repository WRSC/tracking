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
  	assert false, "#{res}\n"
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
    assert false, "#{res}\n"
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
  	assert false, "#{res}"
    #{}"#{res[0][0]} #{res[1][0]} #{res[0][1]} #{res[1][1]}\n"
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
    assert false, "#{res}\n"
  end

  test "should do triangle" do
    attemptSample = Attempt.first
    assert attemptSample.mission_id == 1, "#{attemptSample.mission_id}"

    res = getTimeTriangularCourse(attemptSample)
    assert false, "#{res}\n"

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

    #assert false, "#{myLine[0][0]} #{myLine[1][0]} #{myLine[0][1]} #{myLine[1][1]}"

    assert myLine.length == 2, "#{myLine.length}\n"
    assert myLine[0].length == 2, "#{myLine[0].length}\n"
    assert myLine[1].length == 2, "#{myLine[1].length}\n"

    myBuoy = markers(:secondBuoy)
    buoySample = []
    buoySample.push(myBuoy.longitude)
    buoySample.push(myBuoy.latitude)

    res = checkRoundBuoy(myLine,buoySample,coordSample,"NW")
    assert false, "#{res}"
    #"#{res[0][0]} #{res[1][0]} #{res[0][1]} #{res[1][1]}\n"

  end

  test "should do race" do
    attemptSample = Attempt.first
    assert attemptSample.mission_id == 1, "#{attemptSample.mission_id}"

    res = getTimeRaceCourse(attemptSample)
    assert false, "#{res}\n"

  end

  test "should differ times" do
    res = timeAddition("19930924010303","19700101000001")
    assert false, "#{res}\n" 
  end

end