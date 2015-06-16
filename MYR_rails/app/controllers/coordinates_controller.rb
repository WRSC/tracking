class CoordinatesController < ApplicationController
  before_action :set_coordinate, only: [:show, :edit, :update, :destroy]

  include RealTimeHelper

  NUM_MAX_COORDS = 1000 #constant
  #WARNING limitation is not the one required
  #TO DO global limitation of number of coordinates

  # GET /coordinates
  # GET /coordinates.json
  def index
    @coordinates = Coordinate.all
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
    @coordinate = Coordinate.new(coordinate_params)

    respond_to do |format|
      if @coordinate.save
        format.html { redirect_to @coordinate, notice: 'Coordinate was successfully created.' }
        format.json { render :show, status: :created, location: @coordinate }
      else
        format.html { render :new }
        format.json { render json: @coordinate.errors, status: :unprocessable_entity }
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
    if (params[:datetime] != "0" && params[:datetime] != nil)#the map already contains coordinates
      datetime = params[:datetime].to_datetime
      if (params[:trackers] != nil)# trackers identifiers are specified
        trackers = params[:trackers]
        # order(tracker_id: :asc)  is just here for performance boost -> prevent some action to be made js side by Google Map API
        newCoords = (Coordinate.where(id: Coordinate.order(created_at: :desc).limit(NUM_MAX_COORDS))).where("datetime > ?", datetime).where(tracker_id: trackers).order(tracker_id: :asc).select(:datetime,:tracker_id,:latitude,:longitude)
      else
        #newCoords = (Coordinate.where(id: Coordinate.order(created_at: :desc).limit(NUM_MAX_COORDS))).where("datetime > ?", datetime).order(tracker_id: :asc).select(:datetime,:tracker_id,:latitude,:longitude)
        newCoords = []
      end
      render json: newCoords.to_json #(:only =>[:datetime,:tracker_id,:latitude,:longitude])  -> remove ID but is not a direct SQL request
    else #the map does not have any coordinates
      if getMissionInfos.size > 0 #if there is currently a mission
        start = getMissionInfos[0].to_datetime #missionsInfos = [start, end]
        if (params[:trackers] != nil)# trackers identifiers are specified
          trackers = params[:trackers]
          newCoords = (Coordinate.where(id: Coordinate.order(created_at: :desc).limit(NUM_MAX_COORDS))).where("datetime > ?", start).where(tracker_id: trackers).order(tracker_id: :asc).select(:datetime,:tracker_id,:latitude,:longitude)
        else
          #newCoords = (Coordinate.where(id: Coordinate.order(created_at: :desc).limit(NUM_MAX_COORDS))).where("datetime > ?", start).order(tracker_id: :asc).select(:datetime,:tracker_id,:latitude,:longitude)
          newCoords = []
        end
        render json: newCoords.to_json #(:only =>[:datetime,:tracker_id,:latitude,:longitude])  -> remove ID but is not a direct SQL request
      end
    end
  end

  def gatherCoordsBetweenDates
    if (params[:tstart] != nil && params[:tend] != nil)
      tstart = params[:tstart].to_datetime
      tend = params[:tend].to_datetime
      newCoords = Coordinate.where "? <datetime AND datetime < ?", tstart, tend
      render json: newCoords.to_json(:only =>[:tracker_id,:latitude,:longitude])
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coordinate
      @coordinate = Coordinate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def coordinate_params
      params.require(:coordinate).permit(:latitude, :longitude, :datetime, :tracker_id)
    end
  end
