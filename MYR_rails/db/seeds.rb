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
# case RAILS.env

# when "development"

# #SEEDS for development and test environment
# #specify rake db:reset RAILS_ENV=development to be sure you load them correctly

 	Member.create!(name:  "testAdmin",
 	               email: "example@gmail.com",
 	               password:              "foobar",
 	               password_confirmation: "foobar",
 	               role:     'administrator',
 	               activated: true,
 	               activated_at: Time.zone.now)

 	Mission.create!(name:  "area scanning",
 									start: "20150601000000",
 									end:   "20150901000000",
 	             		mtype: "AreaScanning",
 									category: "Sailboat")

 	i=1
 	20.times do |n|
 		token=i
 		Tracker.create!(token:  "#{i}",
 	             		  description: "It was the #{i} tracker.")
 	  i=i+1
 	end
 	#============= test triangular scores ==============
 	2.times do |n|
 	#id=2-4
 		 Member.create!(name:  "testTriangular#{n}",
 	               email: "testTriangular@gmail.com",
 	               password:              "123456",
 	               password_confirmation: "123456",
 	               role:     'competitor',
 	               activated: true,
 	               activated_at: Time.zone.now,
 	               team_id: n+1)
 	#id=1-2		
 		Team.create!(name:  "testTriangular#{n}'s team",
 	           description: "root test for triangular",
 	           leader_id: 2+n)
 		Robot.create!(name:  "triangular#{n}'s sailrobot",
 	              category: "Sailboat",
 	              team_id: 1+n)
 		2.times do |m|
 			Attempt.create!(name: "triangular#{n}'s attempt",
 									start: "20150601000000",
 									end: "20150901000000",
 									robot_id: 1+2*n,
 									mission_id: 1,
 									tracker_id: m+1+n*2)
 		end

 		Robot.create!(name:  "triangular#{n}'s microsailrobot",
 	              category: "MicroSailboat",
 	              team_id: 1+n)

 		2.times do |m|
 			Attempt.create!(name: "triangular#{n}'s micro attempt",
 									start: "20150601000000",
 									end: "20150901000000",
 									robot_id: 2+2*n,
 									mission_id: 1,
 									tracker_id: 4*n+m+3)

 		end
 	end

# when "production"

	#SEEDS for WRSC2015

	#SEEDS for production mode
	# /!\ BE CAREFUL WHEN CHANGING THIS SEEDS
	# In fact this seeds should be loaded only once before the WRSC2015 ! 
	# After, forget about using rake db:reset because it will suppress all the previous database !!
	# be sure to initialize them by running rake db:reset RAILS_ENV=production

	#Admins
=begin
	Member.create!(name:  "[ADMIN]Sylvain ENSTA",
		               email: "sylvain.hunault@ensta-bretagne.org",
		               password:              "sylvan64",
		               password_confirmation: "sylvan64",
		               role:     'administrator',
		               activated: true,
		               activated_at: Time.zone.now)

	Member.create!(name:  "[ADMIN]Tao ENSTA",
		               email: "tao.zheng@ensta-bretagne.org",
		               password:              "foobar",
		               password_confirmation: "foobar",
		               role:     'administrator',
		               activated: true,
		               activated_at: Time.zone.now)

	Member.create!(name:  "[ADMIN]Anna Friebe ÅUAS",
		               email: "Anna.Friebe@ha.ax",
		               password:              "foobar",
		               password_confirmation: "foobar",
		               role:     'administrator',
		               activated: true,
		               activated_at: Time.zone.now)

	#Missions

	#Triangular Course

	Mission.create!(name:  "Triangular Course Sailboat",
						start: "20150903050000",
						end:   "20150903190000",
	             		mtype: "TriangularCourse",
						category: "Sailboat",
						id: 1)

	Mission.create!(name:  "Triangular Course Micro Sailboat",
						start: "20150903050000",
						end:   "20150903190000",
	             		mtype: "TriangularCourse",
						category: "MicroSailboat",
						id: 2)

	# Fleet Race

	Mission.create!(name:  "Fleet Race Sailboat",
						start: "20150904050000",
						end:   "20150904190000",
	             		mtype: "Race",
						category: "Sailboat",
						id: 3)

	Mission.create!(name:  "Fleet Race Micro Sailboat",
						start: "20150904050000",
						end:   "20150904190000",
	             		mtype: "Race",
						category: "MicroSailboat",
						id: 4)	

	# Station Keeping

	Mission.create!(name:  "Station Keeping Sailboat",
						start: "20150901050000",
						end:   "20150901190000",
	             		mtype: "StationKeeping",
						category: "Sailboat",
						id: 5)

	Mission.create!(name:  "Station Keeping Micro Sailboat",
						start: "20150901050000",
						end:   "20150901190000",
	             		mtype: "StationKeeping",
						category: "MicroSailboat",
						id: 6)

	# Area Scanning

	Mission.create!(name:  "Area Scanning Sailboat",
						start: "20150902050000",
						end:   "20150902220000",
	             		mtype: "AreaScanning",
						category: "Sailboat",
						id: 7)

	Mission.create!(name:  "Area Scanning Micro Sailboat",
						start: "20150902050000",
						end:   "20150902220000",
	             		mtype: "AreaScanning",
						category: "MicroSailboat",
						id: 8)

	#Markers

	# Triangular Course SailBoat

	Marker.create!(name: "firstBuoy",
		mtype: "Point",
		latitude: 60.1050,
		longitude: 19.9500,
		mission_id: 1,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "secondBuoy",
		mtype: "Point",
		latitude: 60.1080,
		longitude: 19.9500,
		mission_id: 1,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "thirdBuoy",
		mtype: "Point",
		latitude: 60.1080,
		longitude: 19.9560,
		mission_id: 1,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "fourthBuoy",
		mtype: "Point",
		latitude: 60.1050,
		longitude: 19.9560,
		mission_id: 1,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "startLine",
		mtype: "Line",
		latitude: "60.1050_60.1080",
		longitude: "19.9500_19.9560",
		mission_id: 1,
		description: "Start line will be decided according to wind direction 12 hours before the mission starts."
		)

	Marker.create!(name: "endLine",
		mtype: "Line",
		latitude: "60.1080_60.1080",
		longitude: "19.9500_19.9560",
		mission_id: 1,
		description: "Finish line will be decided according to wind direction 12 hours before the mission starts."
		)

	# Triangular Course Micro SailBoat

	Marker.create!(name: "firstBuoy",
		mtype: "Point",
		latitude: 60.1050,
		longitude: 19.9500,
		mission_id: 2,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "secondBuoy",
		mtype: "Point",
		latitude: 60.1046,
		longitude: 19.9500,
		mission_id: 2,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "thirdBuoy",
		mtype: "Point",
		latitude: 60.1046,
		longitude: 19.9492,
		mission_id: 2,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "fourthBuoy",
		mtype: "Point",
		latitude: 60.1050,
		longitude: 19.9492,
		mission_id: 2,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "startLine",
		mtype: "Line",
		latitude: "60.1050_60.1046",
		longitude: "19.9500_19.9492",
		mission_id: 2,
		description: "Start line will be decided according to wind direction 12 hours before the mission starts."
		)

	Marker.create!(name: "endLine",
		mtype: "Line",
		latitude: "60.1046_60.1046",
		longitude: "19.9500_19.9492",
		mission_id: 2,
		description: "Finish line will be decided according to wind direction 12 hours before the mission starts."
		)

	# Area Scanning SailBoat

	Marker.create!(name: "firstBuoy",
		mtype: "Point",
		latitude: 60.1050,
		longitude: 19.9500,
		mission_id: 7,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "secondBuoy",
		mtype: "Point",
		latitude: 60.1080,
		longitude: 19.9500,
		mission_id: 7,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "thirdBuoy",
		mtype: "Point",
		latitude: 60.1080,
		longitude: 19.9560,
		mission_id: 7,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "fourthBuoy",
		mtype: "Point",
		latitude: 60.1050,
		longitude: 19.9560,
		mission_id: 7,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "Area Scanning Zone",
		mtype: "Polygon",
		latitude: "60.1050_60.1080_60.1080_60.1050_",
		longitude: "19.9500_19.9500_19.9560_19.9560",
		mission_id: 7,
		description: "Zone for Area Scanning, category Sailboats"
		)


	# Area Scanning Micro SailBoat

	Marker.create!(name: "firstBuoy",
		mtype: "Point",
		latitude: 60.1050,
		longitude: 19.9500,
		mission_id: 8,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "secondBuoy",
		mtype: "Point",
		latitude: 60.1046,
		longitude: 19.9500,
		mission_id: 8,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "thirdBuoy",
		mtype: "Point",
		latitude: 60.1046,
		longitude: 19.9492,
		mission_id: 8,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "fourthBuoy",
		mtype: "Point",
		latitude: 60.1050,
		longitude: 19.9492,
		mission_id: 8,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "Area Scanning Zone",
		mtype: "Polygon",
		latitude: "60.1050_60.1046_60.1046_60.1050_",
		longitude: "19.9500_19.9500_19.9492_19.9492",
		mission_id: 8,
		description: "Zone for Area Scanning, category Micro Sailboats"
		)

	# Fleet Race Sailboat

	Marker.create!(name: "firstBuoy",
		mtype: "Point",
		latitude: 60.1050,
		longitude: 19.9500,
		mission_id: 3,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "secondBuoy",
		mtype: "Point",
		latitude: 60.1080,
		longitude: 19.9500,
		mission_id: 3,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "thirdBuoy",
		mtype: "Point",
		latitude: 60.1080,
		longitude: 19.9560,
		mission_id: 3,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "fourthBuoy",
		mtype: "Point",
		latitude: 60.1050,
		longitude: 19.9560,
		mission_id: 3,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "startLine",
		mtype: "Line",
		latitude: "60.1050_60.1080",
		longitude: "19.9500_19.9560",
		mission_id: 3,
		description: "Start line will be decided according to wind direction 12 hours before the mission starts."
		)

	# Fleet Race Micro Sailboat

	Marker.create!(name: "firstBuoy",
		mtype: "Point",
		latitude: 60.1050,
		longitude: 19.9500,
		mission_id: 4,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "secondBuoy",
		mtype: "Point",
		latitude: 60.1080,
		longitude: 19.9500,
		mission_id: 4,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "thirdBuoy",
		mtype: "Point",
		latitude: 60.1080,
		longitude: 19.9560,
		mission_id: 4,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "fourthBuoy",
		mtype: "Point",
		latitude: 60.1050,
		longitude: 19.9560,
		mission_id: 4,
		description: "Name might change depending on the wind direction"
		)

	Marker.create!(name: "startLine",
		mtype: "Line",
		latitude: "60.1050_60.1080",
		longitude: "19.9500_19.9560",
		mission_id: 4,
		description: "Start line will be decided according to wind direction 12 hours before the mission starts."
		)

	# Station keeping Sailboat

	Marker.create!(name: "firstBuoy",
		mtype: "Point",
		latitude: 60.1050,
		longitude: 19.9500,
		mission_id: 5
		)

	Marker.create!(name: "secondBuoy",
		mtype: "Point",
		latitude: 60.1046,
		longitude: 19.9500,
		mission_id: 5
		)

	Marker.create!(name: "thirdBuoy",
		mtype: "Point",
		latitude: 60.1046,
		longitude: 19.9492,
		mission_id: 5
		)

	Marker.create!(name: "fourthBuoy",
		mtype: "Point",
		latitude: 60.1050,
		longitude: 19.9492,
		mission_id: 5
		)

	Marker.create!(name: "Station Keeping Zone",
		mtype: "Polygon",
		latitude: "60.1050_60.1046_60.1046_60.1050_",
		longitude: "19.9500_19.9500_19.9492_19.9492",
		mission_id: 5,
		description: "Zone for Station Keeping, category Sailboats"
		)


	# Station keeping Micro Sailboat

	Marker.create!(name: "firstBuoy",
		mtype: "Point",
		latitude: 60.1050,
		longitude: 19.9500,
		mission_id: 6
		)

	Marker.create!(name: "secondBuoy",
		mtype: "Point",
		latitude: 60.1046,
		longitude: 19.9500,
		mission_id: 6
		)

	Marker.create!(name: "thirdBuoy",
		mtype: "Point",
		latitude: 60.1046,
		longitude: 19.9492,
		mission_id: 6
		)

	Marker.create!(name: "fourthBuoy",
		mtype: "Point",
		latitude: 60.1050,
		longitude: 19.9492,
		mission_id: 6
		)

	Marker.create!(name: "Station Keeping Zone",
		mtype: "Polygon",
		latitude: "60.1050_60.1046_60.1046_60.1050_",
		longitude: "19.9500_19.9500_19.9492_19.9492",
		mission_id: 6,
		description: "Zone for Station Keeping, category Micro Sailboats"
		)

	i=1
	12.times do |n|
		token=i
		Tracker.create!(token:  "#{i}",
	             		  description: "Tracker #{i}")
	  i=i+1
	end
# end
=end
