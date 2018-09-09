class CoordinatesController < ApplicationController
  before_action :set_coordinate, only: [:show, :edit, :update, :destroy]
  before_filter :authenticateA, only: [:edit, :update, :destroy]
  
  include RealTimeHelper


  #NUM_MAX_COORDS = 1000 #constant
  #WARNING limitation is not the one required
  #TO DO global limitation of number of coordinates

  # GET /coordinates
  # GET /coordinates.json
  def index  
    mesDateTimes=[]
    if cookies[:rdatetimes]!= nil && cookies[:rdatetimes]!= ""
      mesDateTimes=cookies[:rdatetimes].split("_").map { |ts|
        DateTime.strptime(ts, "%Y%m%d%H%S")
      }
    elsif cookies[:rtrieslist]!= nil && cookies[:rtrieslist]!= ""
      trySelect=Try.find_by_id(cookies[:rtrieslist].to_i)
      if trySelect!=nil
        mesDateTimes=[trySelect.start.to_s,trySelect.end.to_s]
      end
    end

    if cookies[:robotCookie]!= nil && cookies[:robotCookie]!= ""
      myRobotId=cookies[:robotCookie]
      if Robot.find_by_id(myRobotId) == nil
        myTrackerId = 0
      else
        myTrackerId = Robot.find_by_id(myRobotId).trackers.ids
      end
    else
      myTrackerId = nil
    end

    if mesDateTimes != nil && mesDateTimes != []
      nbptsmax=599
      if myTrackerId == 0
        allCoordinate=Coordinate.where(datetime: mesDateTimes[0]..mesDateTimes[1])
      else
        allCoordinate=Coordinate.where(datetime: mesDateTimes[0]..mesDateTimes[1]).where(tracker_id: myTrackerId)
      end

      if allCoordinate!=[]
        if sign_A?
            @coordinates = allCoordinate[0..nbptsmax]
        else
          if myTeam != nil
            if myTrackerId == 0
              if Robot.find_by_team_id(myTeam.id) != nil
                #Tracker.find_by_id(Robot.find_by_team_id(myTeam.id).tracker_id)
                myTrackersId = Attempt.where(robot_id: Robot.where(team_id: myTeam.id).ids).pluck(:tracker_id).uniq
                if myTrackersId != nil
                  @coordinates = allCoordinate.where(tracker_id: myTrackersId)[0..nbptsmax]
                else
                  @coordinates =[]
                end
              else
                @coordinates =[]
              end
            else
              @coordinates = allCoordinate.where(tracker_id: myTrackerId)[0..nbptsmax]
            end
          else
            @coordinates =[]
          end
        end
      else
        @coordinates =[]
      end
    else
      @coordinates =[]
    end
  end

  def latest_by_mission
    mission = Mission.find(params[:id])

    limit = params.fetch(:limit, 1).to_i
    if limit < 1 || limit > 500
      render plain: "?limit must be greater than zero and less than 500", status: 400
      return
    end

    latest_coordinates = mission.attempts.map do |attempt|
      coordinates = attempt.coordinates.order(datetime: :desc).first(limit).map do |coordinate|
        coordinate.as_json(only: [:latitude, :longitude]).merge(
          datetime: coordinate.datetime_as_time.iso8601
        )
      end

      {
        tracker_id: attempt.tracker_id,
        robot_id: attempt.robot.id,
        robot_name: attempt.robot.name,
        team_name: attempt.robot.team.name,
        latest_coordinates: coordinates
      }
    end

    render json: latest_coordinates
  end

  # GET /coordinates/1
  # GET /coordinates/1.json
  def show
  end

  # GET /coordinates/new
  def new
    @coordinate = Coordinate.new
  end

  # GET /coordinates/1/edit
  def edit
  end

  # POST /coordinates
  # POST /coordinates.json
  def create

    myTra=Tracker.find_by_id(params[:coordinate][:tracker_id])
    if myTra!=nil 
      if  myTra.token ==params[:coordinate][:token]
        @coordinate = Coordinate.new(coordinate_params)
        #-------création des coordinates a partir d'une liste------
          #création des variables
        lat = []
        long = []
        date = 0
        
        tok = @coordinate.token
        tr_id = @coordinate.tracker_id
        
        #split des strings reçus
        lat = @coordinate.latitude.split("_")
        long = @coordinate.longitude.split("_")
        date = @coordinate.datetime.split("_")
        vitesse = @coordinate.speed.split("_")
        orientation = @coordinate.course.split("_")
        
        #création des coordinates
        # parcours du tableau
        for i in (0..(lat.length-1))
          Coordinate.create(:latitude => lat[i], :longitude => long[i], :datetime => date[i], :tracker_id => tr_id, :token => tok, :speed => vitesse[i], :course => orientation[i])
        end
        #
        #--------------------------------------------------------


        respond_to do |format|
          if (lat.length>0 && long.length>0 && date.length >0)
           # if (lat.length==1)
           #   @coordinate.save
           # end
            format.html { redirect_to @coordinate, notice: 'Coordinate was successfully created.' }
            format.json { render :show, status: :created, location: @coordinate }
          else
            format.html { render :new }
            format.json { render json: @coordinate.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end

  # PATCH/PUT /coordinates/1
  # PATCH/PUT /coordinates/1.json
  def update
    respond_to do |format|
      if @coordinate.update(coordinate_params)
        format.html { redirect_to @coordinate, notice: 'Coordinate was successfully updated.' }
        format.json { render :show, status: :ok, location: @coordinate }
      else
        format.html { render :edit }
        format.json { render json: @coordinate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coordinates/1
  # DELETE /coordinates/1.json
  def destroy
    @coordinate.destroy
    respond_to do |format|
      format.html { redirect_to coordinates_url, notice: 'Coordinate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #retrieves coordinates (ordered by tracker_id) since the begining of the current missions or since the provided datetime
  def gatherCoordsSince
  	m_id=params[:mission_id]
  	datetime=params[:datetime]
    numMaxCoords = params[:numCoords]
  	offset = params[:offset]


  	trackers=[] # change js array into tracker_ids
  	if (params[:trackers] != nil) 
      params[:trackers].each do |k,v|
    		trackers << v
    	end
  	end

    if (datetime != "10000101" && datetime != nil)#the map already contains coordinates
      if (trackers != nil)# trackers identifiers are specified
        # order(tracker_id: :asc)  is just here for performance boost -> prevent some action to be made js side by Google Map API
        newCoords = (Coordinate.where(id: Coordinate.order(datetime: :desc).where("datetime > ?", datetime).where(tracker_id: trackers).limit(numMaxCoords))).where("datetime > ?", datetime).where(tracker_id: trackers).order(tracker_id: :asc).select(:datetime,:tracker_id,:latitude,:longitude)
      else
        newCoords = []
      end
      render json: newCoords.to_json #(:only =>[:datetime,:tracker_id,:latitude,:longitude])  -> remove ID but is not a direct SQL request
    else #the map does not have any coordinates
      if getMissionIds.size > 0 #if there is currently a mission
        if offset.to_i == 0
          start = Mission.find(m_id).start
        else
          start = (Time.now.utc-offset.to_f)
        end
        if (trackers != nil)# trackers identifiers are specified
          newCoords = (Coordinate.where(id: Coordinate.order(datetime: :desc).where("datetime > ?", start).where(tracker_id: trackers).limit(numMaxCoords))).where("datetime > ?", start).where(tracker_id: trackers).where("datetime > ?", datetime).order(tracker_id: :asc).select(:datetime,:tracker_id,:latitude,:longitude)
        else
          newCoords = []
        end
        render json: newCoords.to_json #(:only =>[:datetime,:tracker_id,:latitude,:longitude])  -> remove ID but is not a direct SQL request
      end
    end
  end

  def gatherCoordsBetweenDates
    trackers=params[:trackers]
		if (params[:tstart] != nil && params[:tend] != nil)
      tstart = params[:tstart]
      tend   = params[:tend]
      newCoords = Coordinate.where("? < datetime AND datetime < ?", tstart, tend).where(tracker_id: trackers).order(tracker_id: :asc).order(datetime: :asc)
      render json: newCoords.to_json(:only =>[:tracker_id,:latitude,:longitude,:datetime])
    end
  end

  def gatherCoordsLittleByLittle
    trackers=params[:trackers]
    if (params[:tstart] != nil && params[:tend] != nil)
      tstart = params[:tstart]
      tend   = params[:tend]
      newCoords = Coordinate.where("? <datetime AND datetime < ?", tstart, tend).where(tracker_id: trackers).order(datetime: :asc).limit(10)
      render json: newCoords.to_json(:only =>[:tracker_id,:latitude,:longitude,:datetime])
    end
  end

  #input: array of coordinates
  #output: aray of coordinates
  def limitCoordinates(coordinatesCustom)
    #---------------------------- START Limite coordinate ----------------

    #count the number of trackers
    if coordinatesCustom.size > 0
      coords = coordinatesCustom.order(tracker_id: :asc) #sort coords by tracker_id

      if coordinatesCustom.size > NUM_MAX_COORDS

        nbtra = 1 #give the number of trackers
        coords.each_cons(2) do |element, next_element|
          if next_element != element
            nbtra = nbtra +1
          end
        end

        mycoordinatesCustom=coordinatesCustom.reverse
        sortie=[]
        p=1 
        q=1
        nbpts=0
        nbptsmax=125

        tra=0

        if mycoordinatesCustom != nil
          for j in 0..mycoordinatesCustom.length-1
            if mycoordinatesCustom[j]!= nil
              if mycoordinatesCustom[j].tracker_id != tra
                tra = mycoordinatesCustom[j].tracker_id
                p=1
                q=1
                nbpts=0
              end
              if nbpts < nbptsmax/nbtra
                if q%p == 0
                  sortie=sortie+[mycoordinatesCustom[j]]
                  nbpts=nbpts+1
                end
              end
              if q>=60*p
                p=10*p
              end
              q=q+1
            end
          end
        end
        return sortie.reverse
      else 
        return coords
      end
    else
      return []
    end
  end

  def export
    #selectionner les coordonnées dans la plage de temps
    mesDateTimes=[]
    nbptsmax=100000
    if cookies[:rdatetimes]!= nil && cookies[:rdatetimes]!= ""
      mesDateTimes=cookies[:rdatetimes].split("_") 
    elsif cookies[:rtrieslist]!= nil && cookies[:rtrieslist]!= ""
      trySelect=Try.find_by_id(cookies[:rtrieslist].to_i)
      if trySelect!=nil
        mesDateTimes=[trySelect.start.to_s,trySelect.end.to_s]
      end
    end

    if cookies[:robotCookie]!= nil && cookies[:robotCookie]!= ""
      myRobotId=cookies[:robotCookie]
      if Robot.find_by_id(myRobotId) == nil
        myTrackerId = 0
      else
        myTrackerId = Robot.find_by_id(myRobotId).trackers.pluck(:id).uniq
      end
    else
      myTrackerId = nil
    end

    if mesDateTimes != nil && mesDateTimes != [] && myTrackerId != nil
      if sign_A?
        if myTrackerId == 0
          allCoordinate=Coordinate.where(datetime: mesDateTimes[0]..mesDateTimes[1]).order(datetime: :asc)
        else
          allCoordinate=Coordinate.where(datetime: mesDateTimes[0]..mesDateTimes[1]).where(tracker_id: myTrackerId).order(datetime: :asc)
        end
      else
        if myTeam != nil
          if myTrackerId == 0
            if Robot.find_by_team_id(myTeam.id) != nil
              myTrackersId = Attempt.where(robot_id: Robot.where(team_id: myTeam.id).ids).pluck(:tracker_id).uniq
              if myTrackersId != nil
                allCoordinate = Coordinate.where(datetime: mesDateTimes[0]..mesDateTimes[1]).where(tracker_id: myTrackersId).order(datetime: :asc)
              end
            end
          else
            allCoordinate = Coordinate.where(datetime: mesDateTimes[0]..mesDateTimes[1]).where(tracker_id: myTrackerId).order(datetime: :asc)
          end
        end
      end
    end

    @data = allCoordinate
    respond_to do |format|
      format.html { redirect_to root_url }
      format.csv { send_data @data.to_csv }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coordinate
      @coordinate = Coordinate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def coordinate_params
      params.require(:coordinate).permit(:latitude, :longitude, :datetime, :tracker_id, :token, :speed, :course)
      
    end
  end
