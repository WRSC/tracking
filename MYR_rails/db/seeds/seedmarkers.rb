#SEEDS for WRSC2015

#SEEDS for production mode
# /!\ BE CAREFUL WHEN CHANGING THIS SEEDS
# In fact this seeds should be loaded only once before the WRSC2015 ! 
# After, forget about using rake db:reset because it will suppress all the previous database !!
# be sure to initialize them by running 'RAILS_ENV=production rake db:seed:seedsWRSC2015'
#Admins


#Missions

#Triangular Course


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









