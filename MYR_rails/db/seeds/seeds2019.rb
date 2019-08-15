#SEEDS for WRSC2019

#SEEDS for production mode
# /!\ BE CAREFUL WHEN CHANGING THIS SEEDS
# This seed help to configure admin account and setup missions in the competition.
# Follow example seed file to configure your own. 
# When the seed file is ready run 'RAILS_ENV=production rake db:seed:seeds2019'
# This will add both admin users and missions to the corresponding database.


#Admins

Member.create!(name:  "Yu_Cao",
	               email: "Yu.Cao@soton.ac.uk",
	               password:              "foobar",
	               password_confirmation: "foobar",
	               role:     'administrator',
	               activated: true,
	               activated_at: Time.zone.now)

#Edition

Edition.create!(name: "WRSC 2019",
				id: 2)

#Missions

	#Fleet Race

	Mission.create!(name:  "Fleet Race Sailboat",
					start: "20190705000000",
					end:   "20190826230000",
             		mtype: "Race",
					category: "Sailboat",
					edition_id: 2,
					id: 1)

	#Station Keeping

	Mission.create!(name:  "Station Keeping Sailboat",
					start: "20190827000000",
					end:   "20190827230000",
             		mtype: "StationKeeping",
					category: "Sailboat",
					edition_id: 2,
					id: 2)

	#Area Scanning

	Mission.create!(name:  "Area Scanning Sailboat",
					start: "20190828000000",
					end:   "20190828230000",
             		mtype: "AreaScanning",
					category: "Sailboat",
					edition_id: 2,
					id: 3)

	#Hide and seek

	Mission.create!(name:  "Collision Avoidance Sailboat",
                    start: "20190829000000",
                    end:   "20190829230000",
		     		mtype: "CollisionAvoidance",
					category: "Sailboat",
					edition_id: 2,
					id: 4)

#Markers



#Trackers
i=1
13.times do |n|
	token=i
	Tracker.create!(token:  "#{i}",
         		   description: "Tracker #{i}")
  i=i+1
end

# token1 = Tracker.first!().token

# # Coordinates - for testing the site
# require "csv"
# soton_track_f = File.join(File.dirname(__FILE__), "soton-2018-fleetrace.csv")
# soton_track = CSV.read(soton_track_f, options={headers: true}).map {|row|
# 	Coordinate.new(
# 		datetime: row["datetime"],
# 		latitude: row["latitude"].to_f,
# 		longitude: row["longitude"].to_f,
# 		speed: row["speed"].to_f,
# 		course: row["course"].to_f,
# 		tracker_id: 1,
# 		token: token1,
# 	)
# }
# Coordinate.import(soton_track)

# Team.create(
# 	name: "Southampton",
# 	id: 1,
# )

# Robot.create(
# 	name: "Black Python",
# 	category: "MicroSailboat",
# 	team_id: 1,
# 	id: 1,
# )

# Attempt.create(
# 	name: "Soton fleet 1",
# 	start: "20180827120000",
# 	end: "20180827160000",
# 	mission_id: 2,
# 	robot_id: 1,
# 	tracker_id: 1,
# )
