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


Member.create!(name:  "joker",
               email: "joker@gmail.com",
               password:              "foobar",
               password_confirmation: "foobar",
               role:     'visitor',
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

Member.find(2).update_attribute(:team_id, 1)
Member.find(3).update_attribute(:team_id, 2)
Member.find(4).update_attribute(:team_id, 3)

i=1
9.times do |n|
	token=i
	Tracker.create!(token:  "#{i}",
             		  description: "It was the #{i} tracker.")
  i=i+1
end

for rob_id in 1..9
			name = Faker::Name.name
			Attempt.create!(name: name,
											start: "20150601000000",
											end:   "20150901000000",
											robot_id: rob_id,
											mission_id: 1,
											tracker_id: rob_id)
      name = Faker::Name.name
      Attempt.create!(name: name,
                      start: "20150601000000",
                      end:   "20150901000000",
                      robot_id: rob_id,
                      mission_id: 2,
                      tracker_id: rob_id)
      name = Faker::Name.name
      Attempt.create!(name: name,
                      start: "20150601000000",
                      end:   "20150901000000",
                      robot_id: rob_id,
                      mission_id: 3,
                      tracker_id: rob_id)
      name = Faker::Name.name
      Attempt.create!(name: name,
                      start: "20150601000000",
                      end:   "20150901000000",
                      robot_id: rob_id,
                      mission_id: 4,
                      tracker_id: rob_id)
end

#One tracker per robot

#Coordinates to test the performance
# for k in 0..29
#   for j in 0..23
#     for i in 0..59
#       date = 20150601000000+ i*100 + j*10000 + k*1000000;
#       lat = 1+(i+j*60+k*60*24).to_f/1000;
#       long = (i+j*60+k*60*24).to_f/1000-1;
#       Coordinate.create!(latitude:  lat,
#                     longitude: long,
#                     datetime:   date,
#                     tracker_id: 1)
#     end
#   end
# end

# #for k in 0..29
#   for j in 0..23
#     for i in 0..59
#       date = 20150601000000+ i*100 + j*10000;
#       lat = 7+(i+j*60).to_f/1000;
#       long = 4+(i+j*60).to_f/1000;
#       Coordinate.create!(latitude:  lat,
#                     longitude: long,
#                     datetime:   date,
#                     tracker_id: 2)
#     end
#   end
#end

#Tracker 1~8 => robot 1
#Tracker 1 2 => robot 1 mission 1 => attempt1 attempt2
#Tracker 3 4 => robot 1 mission 2 => attempt3 attempt4
#Tracker 5 6 => robot 1 mission 3 => attempt5 attempt6
#Tracker 7 8 => robot 1 mission 4 => attempt7 attempt8

#markers

#markers for triangular course

# Marker.create!(latitude: 0,
#             longitude: 0,
#             mission_id: 4,
#             mtype: "Point")

# Marker.create!(latitude: 1,
#             longitude: 0,
#             mission_id: 4,
#             mtype: "Point")

# Marker.create!(latitude: 0,
#             longitude: 1,
#             mission_id: 4,
#             mtype: "Point")

#markers for race course

Marker.create!(longitude: "0_1",
            latitude: "0_0",
            mission_id: 4,
            mtype: "Line")

Marker.create!(longitude: 0,
            latitude: 0,
            mission_id: 4,
            mtype: "Point")

Marker.create!(longitude: 0,
            latitude: 1, 
            mission_id: 4,
            mtype: "Point")

Marker.create!(longitude: -1,
            latitude: 1, 
            mission_id: 4,
            mtype: "Point")

Marker.create!(longitude: -1,
            latitude: 0, 
            mission_id: 4,
            mtype: "Point")

#http://programming-tut.blogspot.com/2009/09/ruby-on-rails-time.html

#Coordinates => test for triangular course scoring
  # lat=0
  # lng=0
  # i=1
  # t=Time.now

  # Coordinate.create!(latitude:  -0.5,
  #                 longitude: 0.5,
  #                 datetime:   t.strftime("%Y%m%d%H%M%S"),
  #                 tracker_id: 4)

  # t=t+5

  # Coordinate.create!(latitude:  0.5,
  #                 longitude: 0.5,
  #                 datetime:   t.strftime("%Y%m%d%H%M%S"),
  #                 tracker_id: 4)

  # t=t+5



  # 50.times do |n|
  #   lat = 1 + Math.sin(i)/3
  #   lng = Math.cos(i)/3
  #   Coordinate.create!(latitude:  lat,
  #                   longitude: lng,
  #                   datetime:   t.strftime("%Y%m%d%H%M%S"),
  #                   tracker_id: 4)
  #   t=t+5
  #   i=i+0.1
  # end

  # i = 1 

  # 55.times do |n|
  #   lat = Math.sin(i)/3
  #   lng = 1 + Math.cos(i)/3
  #   Coordinate.create!(latitude:  lat,
  #                   longitude: lng,
  #                   datetime:   t.strftime("%Y%m%d%H%M%S"),
  #                   tracker_id: 4)
  #   t=t+5
  #   i=i-0.1
  # end

  #   Coordinate.create!(latitude:  0.5,
  #                 longitude: -0.5,
  #                 datetime:   t.strftime("%Y%m%d%H%M%S"),
  #                 tracker_id: 4)

# Coordinate => test for race course

  lat=0
  lng=0
  i=-0.8
  t=Time.now

  Coordinate.create!(longitude: 0.5,
                  latitude: -0.5,
                  datetime:   t.strftime("%Y%m%d%H%M%S"),
                  tracker_id: 4)

  t = t + 5

  Coordinate.create!(longitude: 0.5,
              latitude: 0.5,
              datetime:   t.strftime("%Y%m%d%H%M%S"),
              tracker_id: 4)

  t = t + 5

  20.times do |n|
    lat = 1 + Math.sin(i)/3
    lng = Math.cos(i)/3
    Coordinate.create!(latitude:  lat,
                    longitude: lng,
                    datetime:   t.strftime("%Y%m%d%H%M%S"),
                    tracker_id: 4)
    t=t+5
    i=i+0.1
  end

  Coordinate.create!(longitude: -0.5,
              latitude: 1.2,
              datetime:   t.strftime("%Y%m%d%H%M%S"),
              tracker_id: 4)

  t = t + 5

  i = 0.75 

  20.times do |n|
    lat = 1 + Math.sin(i)/3
    lng = Math.cos(i)/3 -1
    Coordinate.create!(latitude:  lat,
                    longitude: lng,
                    datetime:   t.strftime("%Y%m%d%H%M%S"),
                    tracker_id: 4)
    t=t+5
    i=i+0.1
  end

  Coordinate.create!(longitude: -1.2,
              latitude: 0.5,
              datetime:   t.strftime("%Y%m%d%H%M%S"),
              tracker_id: 4)

  t = t + 5

  i = 2.4
  20.times do |n|
    lat = Math.sin(i)/3
    lng = Math.cos(i)/3 -1
    Coordinate.create!(latitude:  lat,
                    longitude: lng,
                    datetime:   t.strftime("%Y%m%d%H%M%S"),
                    tracker_id: 4)
    t=t+5
    i=i+0.1
  end

  Coordinate.create!(longitude: -0.5,
              latitude: -0.2,
              datetime:   t.strftime("%Y%m%d%H%M%S"),
              tracker_id: 4)

  t = t + 5  

  i = -2.4
  20.times do |n|
    lat = Math.sin(i)/3
    lng = Math.cos(i)/3
    Coordinate.create!(latitude:  lat,
                    longitude: lng,
                    datetime:   t.strftime("%Y%m%d%H%M%S"),
                    tracker_id: 4)
    t=t+5
    i=i+0.1
  end

  Coordinate.create!(longitude: 0.2,
              latitude: 0.2,
              datetime:   t.strftime("%Y%m%d%H%M%S"),
              tracker_id: 4)

  t = t + 5  

#Coordinate  => attempt1
 # lat=0
 # lng=0
 # i=0
 # t=Time.now
 # 100.times do |n|
 # 	Coordinate.create!(latitude:  lat,
 # 									longitude: lng,
 # 									datetime:   t.strftime("%Y%m%d%H%M%S"),
 # 		           		tracker_id: 1)

 # 	lng=5*Math.cos(i)
 # 	t=t+5
 # 	lat=5*Math.sin(i)
 # 	i=i+0.1
 # end
             		


#Coordinate => attempt2
# Coordinate.create!(latitude:  5,
# 								longitude: 5,
# 								datetime:   "20150709132700",
#              		tracker_id: 2)
             		
# Coordinate.create!(latitude:  5,
# 								longitude: 10,
# 								datetime:   "20150709132712",
#              		tracker_id: 2)

# Coordinate.create!(latitude:  10,
# 								longitude: 5,
# 								datetime:   "20150709132721",
#              		tracker_id: 2)
             		
# #Coordinate => attempt3
# Coordinate.create!(latitude:  30,
# 								longitude: 5,
# 								datetime:   "20150709132700",
#              		tracker_id: 3)
             		
# Coordinate.create!(latitude:  30,
# 								longitude: 10,
# 								datetime:   "20150709132712",
#              		tracker_id: 3)

# Coordinate.create!(latitude:  35,
# 								longitude: 5,
# 								datetime:   "20150709132721",
#              		tracker_id: 3)

#Mission 1
Mission.create!(name:  "Triangular Course Contest",
								start: "20150601000000",
								end:   "20150901000000",
             		description: "It was the first mission")

#Mission 2
Mission.create!(name:  "Station-Keeping Contest",
								start: "20150601000000",
								end:   "20150901000000",
             		description: "It was the second mission")
             		
#Mission 3
Mission.create!(name:  "Area Scanning Contest",
								start: "20150601000000",
								end:   "20150901000000",
             		description: "It was the third mission")
#Mission 4
Mission.create!(name:  "Fleet Race",
								start: "20150601000000",
								end:   "20150901000000",
             		description: "It was the fourth mission")

#team 1
Team.create!(name:  "Zombie",
             description: "root test for zombies",
             leader_id: 2,
             logo: 'http://avatarbox.net/avatars/img5/rubber_ducky_avatar_picture_87102.jpg')

#robot1 
Robot.create!(name:  "Zombie1",
              category: "MicroSailboat",
              team_id: 1)
              
#robot2 
Robot.create!(name:  "Zombie2",
              category: "MicroSailboat",
              team_id: 1)
              
#robot3 
Robot.create!(name:  "Zombie3",
              category: "Sailboat",
              team_id: 1)
#team 2        
Team.create!(name: "Pizza",
						 description: "root test for pizzas",
						 leader_id: 3,
             logo: 'http://avatarbox.net/avatars/img5/rubber_ducky_avatar_picture_87102.jpg')    
						 
#robot4 
Robot.create!(name:  "Pizza1",
              category: "MicroSailboat",
              team_id: 2)
              
#robot5 
Robot.create!(name:  "Pizza2",
              category: "MicroSailboat",
              team_id: 2)
              
#robot6 
Robot.create!(name:  "Pizza3",
              category: "Sailboat",
              team_id: 2) 	 

#team 3						 
Team.create!(name: "Just for fun",
						 description: "root test for just for fun",
						 leader_id: 4,
             logo: 'http://avatarbox.net/avatars/img5/rubber_ducky_avatar_picture_87102.jpg')   

#robot7 
Robot.create!(name:  "just for fun1",
              category: "MicroSailboat",
              team_id: 3)
              
#robot8 
Robot.create!(name:  "Just for fun2",
              category: "MicroSailboat",
              team_id: 3)
              
#robot9 
Robot.create!(name:  "Just for fun3",
              category: "Sailboat",
              team_id: 3) 	 


50.times do |n|
   name = Faker::Name.name
   Robot.create!(name:  name,
              category: "Sailboat",
              team_id: 3) 	 
end

#================ Create some scores to test ================
t=Time.now
20.times do |n|
	Score.create!(
    :attempt_id => n+1,
      :timecost => n*10,
      :rawscore => n%10+0.1*n,
       :penalty => 1,
     :datetimes => Time.now+n
)
end

