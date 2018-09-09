#SEEDS for WRSC2018

#SEEDS for production mode
# /!\ BE CAREFUL WHEN CHANGING THIS SEEDS
# This seed help to configure admin account and setup missions in the competition.
# Follow example seed file to configure your own. 
# When the seed file is ready run 'RAILS_ENV=production rake db:seed:seeds2018'
# This will add both admin users and missions to the corresponding database.


#Admins

Member.create!(name:  "Yu Cao",
	               email: "Yu.Cao@soton.ac.uk",
	               password:              "foobar",
	               password_confirmation: "foobar",
	               role:     'administrator',
	               activated: true,
	               activated_at: Time.zone.now)

Member.create!(name:  "Thomas Kluyver",
	               email: "thomas@kluyver.me.uk",
	               password:              "foobar",
	               password_confirmation: "foobar",
	               role:     'administrator',
	               activated: true,
	               activated_at: Time.zone.now)

Member.create!(name:  "Captain Seb",
	               email: "sebastien.lemaire@soton.ac.uk",
	               password:              "foobar",
	               password_confirmation: "foobar",
	               role:     'administrator',
	               activated: true,
	               activated_at: Time.zone.now)

#Edition

Edition.create!(name: "WRSC 2018",
				id: 1)

#Missions

	#Fleet Race

	Mission.create!(name:  "Fleet Race Sailboat",
					start: "20180705000000",
					end:   "20180827230000",
             		mtype: "Race",
					category: "Sailboat",
					edition_id: 1,
					id: 1)

	Mission.create!(name:  "Fleet Race Micro Sailboat",
					start: "20180705000000",
					end:   "20180827230000",
             		mtype: "Race",
					category: "MicroSailboat",
					edition_id: 1,
					id: 2)	

	#Station Keeping

	Mission.create!(name:  "Station Keeping Sailboat",
					start: "20180828000000",
					end:   "20180828230000",
             		mtype: "StationKeeping",
					category: "Sailboat",
					edition_id: 1,
					id: 3)

	Mission.create!(name:  "Station Keeping Micro Sailboat",
					start: "20180828000000",
					end:   "20180828230000",
             		mtype: "StationKeeping",
					category: "MicroSailboat",
					edition_id: 1,
					id: 4)

	#Area Scanning

	Mission.create!(name:  "Area Scanning Sailboat",
					start: "20180829000000",
					end:   "20180829230000",
             		mtype: "AreaScanning",
					category: "Sailboat",
					edition_id: 1,
					id: 5)

	Mission.create!(name:  "Area Scanning Micro Sailboat",
					start: "20180829000000",
					end:   "20180829230000",
             		mtype: "AreaScanning",
					category: "MicroSailboat",
					edition_id: 1,
					id: 6)

	#Collision Avoidance

	Mission.create!(name:  "Collision Avoidance Sailboat",
                    start: "20180830000000",
                    end:   "20180830230000",
		     		mtype: "CollisionAvoidance",
					category: "Sailboat",
					edition_id: 1,
					id: 7)

	Mission.create!(name:  "Collision Avoidance Micro Sailboat",
					start: "20180830000000",
					end:   "20180830230000",
		     		mtype: "CollisionAvoidance",
					category: "MicroSailboat",
					edition_id: 1,
					id: 8)

#Markers



#Trackers
i=1
13.times do |n|
	token=i
	Tracker.create!(token:  "#{i}",
         		   description: "Tracker #{i}")
  i=i+1
end

# Coordinates - for testing the site
require "csv"
soton_track_f = File.join(File.dirname(__FILE__), "soton-2018-fleetrace.csv")
soton_track = CSV.read(soton_track_f, options={headers: true}).map {|row|
	Coordinate.new(
		datetime: row["datetime"],
		latitude: row["latitude"].to_f,
		longitude: row["longitude"].to_f,
		speed: row["speed"].to_f,
		course: row["course"].to_f,
		tracker_id: 1,
	)
}
Coordinate.import(soton_track)

Team.create(
	name: "Southampton",
	id: 1,
)

Robot.create(
	name: "Black Python",
	category: "MicroSailboat",
	team_id: 1,
	id: 1,
)

Attempt.create(
	name: "Soton fleet 1",
	start: "20180827120000",
	end: "20180827160000",
	mission_id: 2,
	robot_id: 1,
	tracker_id: 1,
)
