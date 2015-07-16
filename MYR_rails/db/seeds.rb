# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#http://stackoverflow.com/questions/10301794/difference-between-rake-dbmigrate-dbreset-and-dbschemaload
Member.create!(name:  "testAdmin",
               email: "example@gmail.com",
               password:              "foobar",
               password_confirmation: "foobar",
               role:     'administrator',
               activated: true,
               activated_at: Time.zone.now)

10.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  password = "password"
  Member.create!(name:  name,
                 email: email,
                 password:              password,
                 password_confirmation: password,
                 role:     'visitor',
                 activated: true,
                 activated_at: Time.zone.now)
end

i=1
72.times do |n|
	token=i
	Tracker.create!(token:  "#{i}",
             		  description: "It was the #{i} tracker.")
  i=i+1
end

i=1
for rob_id in 1..9
	for m_id in 1..4
		for att in 1..2
			name = Faker::Name.name
			Attempt.create!(name: name,
											start: "20150601000000",
											end:   "20150801000000",
											robot_id: rob_id,
											mission_id: m_id,
											tracker_id: i)
			i=i+1
		end
	end
end

#Tracker 1~8 => robot 1
#Tracker 1 2 => robot 1 mission 1 => attempt1 attempt2
#Tracker 3 4 => robot 1 mission 2 => attempt3 attempt4
#Tracker 5 6 => robot 1 mission 3 => attempt5 attempt6
#Tracker 7 8 => robot 1 mission 4 => attempt7 attempt8

#http://programming-tut.blogspot.com/2009/09/ruby-on-rails-time.html
#Coordinate  => attempt1
lat=0
lng=0
i=0
t=Time.now
100.times do |n|
	Coordinate.create!(latitude:  lat,
									longitude: lng,
									datetime:   t.strftime("%Y%m%d%H%M%S"),
		           		tracker_id: 1)

	lng=5*Math.cos(i)
	t=t+5
	lat=5*Math.sin(i)
	i=i+0.1
end
             		


#Coordinate => attempt2
Coordinate.create!(latitude:  5,
								longitude: 5,
								datetime:   "20150709132700",
             		tracker_id: 2)
             		
Coordinate.create!(latitude:  5,
								longitude: 10,
								datetime:   "20150709132712",
             		tracker_id: 2)

Coordinate.create!(latitude:  10,
								longitude: 5,
								datetime:   "20150709132721",
             		tracker_id: 2)
             		
#Coordinate => attempt3
Coordinate.create!(latitude:  30,
								longitude: 5,
								datetime:   "20150709132700",
             		tracker_id: 3)
             		
Coordinate.create!(latitude:  30,
								longitude: 10,
								datetime:   "20150709132712",
             		tracker_id: 3)

Coordinate.create!(latitude:  35,
								longitude: 5,
								datetime:   "20150709132721",
             		tracker_id: 3)

#Mission 1
Mission.create!(name:  "Triangular Course Contest",
								start: "20150601000000",
								end:   "20150801000000",
             		description: "It was the first mission")

#Mission 2
Mission.create!(name:  "Station-Keeping Contest",
								start: "20150601000000",
								end:   "20150801000000",
             		description: "It was the second mission")
             		
#Mission 3
Mission.create!(name:  "Area Scanning Contest",
								start: "20150601000000",
								end:   "20150801000000",
             		description: "It was the third mission")
#Mission 4
Mission.create!(name:  "Fleet Race",
								start: "20150601000000",
								end:   "20150801000000",
             		description: "It was the fourth mission")

#team 1
Team.create!(name:  "Zombie",
             description: "root test for zombies",
             leader_id: 1)

#robot1 
Robot.create!(name:  "Zombie1",
              category: "Small",
              team_id: 1)
              
#robot2 
Robot.create!(name:  "Zombie2",
              category: "Small",
              team_id: 1)
              
#robot3 
Robot.create!(name:  "Zombie3",
              category: "Small",
              team_id: 1)
#team 2        
Team.create!(name: "Pizza",
						 description: "root test for pizzas",
						 leader_id: 1)    
						 
#robot4 
Robot.create!(name:  "Pizza1",
              category: "Small",
              team_id: 2)
              
#robot5 
Robot.create!(name:  "Pizza2",
              category: "Small",
              team_id: 2)
              
#robot6 
Robot.create!(name:  "Pizza3",
              category: "Small",
              team_id: 2) 	 

#team 3						 
Team.create!(name: "just for fun",
						 description: "root test for just for fun",
						 leader_id: 1)   

#robot7 
Robot.create!(name:  "just for fun1",
              category: "Small",
              team_id: 3)
              
#robot8 
Robot.create!(name:  "just for fun2",
              category: "Small",
              team_id: 3)
              
#robot9 
Robot.create!(name:  "just for fun3",
              category: "Small",
              team_id: 3) 	 


