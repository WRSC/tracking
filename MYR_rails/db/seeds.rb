# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#http://stackoverflow.com/questions/10301794/difference-between-rake-dbmigrate-dbreset-and-dbschemaload

#final markers
#60,10500, 19,95000
#60,10800, 19,95000
#60,10800, 19,95600
#60,10500, 19,95600

Member.create!(name:  "testAdmin",
               email: "example@gmail.com",
               password:              "foobar",
               password_confirmation: "foobar",
               role:     'administrator',
               activated: true,
               activated_at: Time.zone.now)

i=1
9.times do |n|
	token=i
	Tracker.create!(token:  "#{i}",
             		  description: "It was the #{i} tracker.")
  i=i+1
end


#================= test for triangular course ==================
#markers for triangular course

#Mission 1
Mission.create!(name:  "Triangular Course Contest",
								start: "20150601000000",
								end:   "20150901000000",
             		mtype: "TriangularCourse",
								category: "Sailboat")

 Marker.create!(latitude: '0_5',
             longitude: '0_0',
             mission_id: 1,
             mtype: "Line",
						 name: 'startLine')

 Marker.create!(latitude: '0_0',
             longitude: '0_5',
             mission_id: 1,
             mtype: "Line",
						 name: 'endLine')

 Marker.create!(latitude: 5,
             longitude: 0,
             mission_id: 1,
             mtype: "Point",
						 name: 'secondBuoy')

 Marker.create!(latitude: 0,
             longitude: 5,
             mission_id: 1,
             mtype: "Point",
						 name: 'firstBuoy')

#id=2
 Member.create!(name:  "testTriangular",
               email: "testTriangular@gmail.com",
               password:              "123456",
               password_confirmation: "123456",
               role:     'competitor',
               activated: true,
               activated_at: Time.zone.now)

#id=1
 Team.create!(name:  "testTriangular's team",
             description: "root test for triangular",
             leader_id: 2)
#id=1
 Robot.create!(name:  "first triangular",
              category: "Sailboat",
              team_id: 1)
#id=1
 Attempt.create!(name: "first triangular first attempt",
							start: "20150601000000",
							end: "20150901000000",
							robot_id: 1,
							mission_id: 1,
							tracker_id: 1)

#http://programming-tut.blogspot.com/2009/09/ruby-on-rails-time.html

#Coordinates => test for triangular course scoring
=begin
    
.(-2,6)-------.(2,6)
 \    m(0,5)  |             m(5,5)
	\						.(2,4)
              |
              |
							.(2,1)
      m(0,0)  |             m(5,0)      
              |
							.(2,-1)
=end
  lat=2
  lng=-1
  t=Time.now
		Coordinate.create!(latitude: lat,
		                 longitude: lng,
		                 datetime:   t.strftime("%Y%m%d%H%M%S"),
		                 tracker_id: 1)
		 t=t+5
  i=1

	7.times do |n|
		lng+=1.01
		Coordinate.create!(latitude: lat,
		                 longitude: lng,
		                 datetime:   t.strftime("%Y%m%d%H%M%S"),
		                 tracker_id: 1)
		 t=t+5
	end

	4.times do |n|
		lat-=1
  	Coordinate.create!(latitude:  lat,
                   longitude: lng,
                   datetime:   t.strftime("%Y%m%d%H%M%S"),
                   tracker_id: 1)

   	t=t+5
	end

	2.times do |n|
		lng-=1
		Coordinate.create!(latitude:  lat,
                   longitude: lng,
                   datetime:   t.strftime("%Y%m%d%H%M%S"),
                   tracker_id: 1)		
		t=t+5	
	end

	8.times do |n|
		lat+=1
		lng-=0.25
		Coordinate.create!(latitude:  lat,
                   longitude: lng,
                   datetime:   t.strftime("%Y%m%d%H%M%S"),
                   tracker_id: 1)		
		t=t+5	
	end

	lng-=3
	Coordinate.create!(latitude:  lat,
                   longitude: lng,
                   datetime:   t.strftime("%Y%m%d%H%M%S"),
                   tracker_id: 1)		
	t=t+5	

	lat-=2
	Coordinate.create!(latitude:  lat,
                   longitude: lng,
                   datetime:   t.strftime("%Y%m%d%H%M%S"),
                   tracker_id: 1)		
	t=t+5	

	5.times do |n|
		lat-=1
		lng+=0.4
		Coordinate.create!(latitude:  lat,
                   longitude: lng,
                   datetime:   t.strftime("%Y%m%d%H%M%S"),
                   tracker_id: 1)		
		t=t+5	
	end

#================= test for station keeping ==================
#Mission 2
Mission.create!(name: "Station-Keeping Contest",
							start: "20150601000000",
							end: "20150901000000",
							mtype: "StationKeeping",
							category: "Sailboat")

Marker.create!(latitude: '0_5_5_0',
             longitude: '0_0_5_5',
             mission_id: 2,
             mtype: "Polygon",
						 name: 'station keeping zone')
#id=3
Member.create!(name:  "testStationkeeping",
               email: "testStationkeeping@gmail.com",
               password:              "123456",
               password_confirmation: "123456",
               role:     'competitor',
               activated: true,
               activated_at: Time.zone.now)

#id=2
 Team.create!(name:  "testStationkeeping's team",
             description: "root test for triangular",
             leader_id: 3)
#id=2
 Robot.create!(name:  "station keeping",
              category: "Sailboat",
              team_id: 2)
#id=2
 Attempt.create!(name: "testStationkeeping's first attempt",
							start: "20150601000000",
							end: "20150901000000",
							robot_id: 2,
							mission_id: 2,
							tracker_id: 2)
	
  t=Time.now
	lat=2.5
	lng=-1
	r=2.5
	5.times do |n|
		lng+=0.2
		Coordinate.create!(latitude:  lat,
		               longitude: lng,
		               datetime:   t.strftime("%Y%m%d%H%M%S"),
		               tracker_id: 2)		
		t=t+5	
	end
	theta=-Math::PI/2
	for i in 1..300
      t+=1
			theta+=2*Math::PI/10
      lat=2.5+r*Math::cos(theta)
      lng=2.5+r*Math::sin(theta)
      Coordinate.create!( latitude: lat, longitude: lng, datetime: t.strftime("%Y%m%d%H%M%S"), tracker_id: 2 )
	end
	for i in 1..10
      t+=1
      lng-=0.1
      Coordinate.create!( latitude: lat, longitude: lng, datetime: t.strftime("%Y%m%d%H%M%S"), tracker_id: 2 )
    end
#================= test for area scanning ===============
Mission.create!(name: "Area Scanning Contest",
							start: "20150601000000",
							end: "20150901000000",
							mtype: "AreaScanning",
							category: "Sailboat")

 Marker.create!(latitude: 0,
             longitude: 0,
             mission_id: 1,
             mtype: "Point",
						 name: 'firstBuoy')

 Marker.create!(latitude: 0,
             longitude: 5,
             mission_id: 1,
             mtype: "Point",
						 name: 'secondBuoy')

 Marker.create!(latitude: 5,
             longitude: 5,
             mission_id: 1,
             mtype: "Point",
						 name: 'thirdBuoy')

 Marker.create!(latitude: 5,
             longitude: 0,
             mission_id: 1,
             mtype: "Point",
						 name: 'fourthBuoy')

#id=4
Member.create!(name:  "testAreaScanning",
               email: "testAreaScanning@gmail.com",
               password:              "123456",
               password_confirmation: "123456",
               role:     'competitor',
               activated: true,
               activated_at: Time.zone.now)

#id=3
 Team.create!(name:  "testtestAreaScanning's team",
             description: "root test for testAreaScanning",
             leader_id: 4)
#id=3
 Robot.create!(name:  "testAreaScanning",
              category: "MicroSailboat",
              team_id: 3)
#id=3
 Attempt.create!(name: "testAreaScanning's first attempt",
							start: "20150601000000",
							end: "20150901000000",
							robot_id: 3,
							mission_id: 3,
							tracker_id: 3)
	
#================= test for fleet race ==================
#Mission 4

t=Time.now
#id=4
Mission.create!(name: "fleet-race Contest",
							start: "20150601000000",
							end: "20150901000000",
							mtype: "Race",
							category: "Sailboat",
							startOfRace: t.strftime("%Y%m%d%H%M%S"))

Marker.create!(latitude: '0_0',
             longitude: '0_-1',
             mission_id: 4,
             mtype: "Line",
						 name: 'startLine')

 Marker.create!(latitude: 0,
             longitude: 0,
             mission_id: 4,
             mtype: "Point",
						 name: 'firstBuoy')

 Marker.create!(latitude: 5,
             longitude: 0,
             mission_id: 4,
             mtype: "Point",
						 name: 'secondBuoy')

 Marker.create!(latitude: '5',
             longitude: '5',
             mission_id: 4,
             mtype: "Point",
						 name: 'thirdBuoy')

Marker.create!(latitude: '0',
             longitude: '5',
             mission_id: 4,
             mtype: "Point",
						 name: 'fourthBuoy')
#id=5
Member.create!(name:  "testFleetrace",
               email: "testFleetrace@gmail.com",
               password:              "123456",
               password_confirmation: "123456",
               role:     'competitor',
               activated: true,
               activated_at: Time.zone.now)

#id=4
 Team.create!(name:  "testFleetrace's team",
             description: "root test for testFleetrace",
             leader_id: 5)
#id=4
 Robot.create!(name:  "testFleetrace",
              category: "Sailboat",
              team_id: 4)
#id=4
 Attempt.create!(name: "testFleetrace's first attempt",
							start: "20150601000000",
							end: "20150901000000",
							robot_id: 4,
							mission_id: 4,
							tracker_id: 4)
	
 	lat=-0.5
	lng=-0.5
	r=Math::sqrt(3*3+2.5*2.5)
	theta=-Math::PI/2
	for i in 1..70
      t+=1
      Coordinate.create!( latitude: lat, longitude: lng, datetime: t.strftime("%Y%m%d%H%M%S"), tracker_id: 3)
			theta-=2*Math::PI/10
      lat=2.5+r*Math::cos(theta)
      lng=2.5+r*Math::sin(theta)

	end
=begin
  5.times do |n|
 		 Attempt.create!(name: "testStationKeeping's #{n} attempt",
							start: "20150601000000",
							end: "20150901000000",
							robot_id: 4,
							mission_id: 2,
							tracker_id: n+5)
	end
=end
	5.times do |n|
		 Attempt.create!(name: "testTriangular's #{n} attempt",
							start: "20150601000000",
							end: "20150901000000",
							robot_id: 2,
							mission_id: 1,
							tracker_id: n+5)	
	end
