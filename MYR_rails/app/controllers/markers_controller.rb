class MarkersController < ApplicationController
  before_action :set_marker, only: [:show, :edit, :update, :destroy]

  # GET /markers
  # GET /markers.json
  def index
    @markers = Marker.all
  end

  # GET /markers/1
  # GET /markers/1.json
  def show
  end

  def map
    @missions = Mission.all
  end

  # GET /markers/new
  def new
    @marker = Marker.new
    t=Time.now
    t.strftime("%Y%m%d%H%M%S")
		year=t.strftime("%Y").to_i
		month=t.strftime("%m").to_i
		t_rest= t.strftime("%d%H%M%S")
		#start time for the inteval of mission
		if month <=6 
			lmonth=month+12-6
			lyear=year-1
		else
    	lmonth=month-6
    	lyear=year
    end
    #@tstart=(lyear.to_s+lmonth.to_s+t_rest)
    if lmonth < 10 
    	lmonth='0'+lmonth.to_s 
    else
    	lmonth=lmonth.to_s 
    end
    @tstart=(lyear.to_s+lmonth.to_s+t_rest).to_datetime
    #end time for the inteval of mission
    if month >=6
			rmonth=month-12+6
			ryear=year+1
		else
    	rmonth=month+6
    	ryear=year
    end
    if rmonth < 10  
    	rmonth='0'+rmonth.to_s  
    end
    @tend=(ryear.to_s+rmonth.to_s+t_rest).to_datetime
    @missions=Mission.where("? <=start AND end <= ?", @tstart, @tend)
  end

  # GET /markers/1/edit
  def edit
  end

  # POST /markers
  # POST /markers.json
  def create
    @marker=Marker.new(marker_params)
    tablat=@marker.latitude.split(";")
    tablng=@marker.longitude.split(";")
    tabname=@marker.name.split(";")
    flag=false
    for i in (0..tablat.length-1)
      if tablat[i]!="" && tablat[i]!=nil
        flag=Marker.create(datetime: @marker.datetime, mission_id: @marker.mission_id, latitude: tablat[i], longitude: tablng[i], mtype: @marker.mtype,name: tabname[i])
      end
    end
    
    #@marker = Marker.new(marker_params)
    #need to check
    respond_to do |format|
      if flag #if flag==true all coordinates were saved
        format.html { redirect_to @marker, notice: 'Marker was successfully created.' }
        format.json { render :show, status: :created, location: @marker }
      else
        format.html { render :new }
        format.json { render json: @marker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /markers/1
  # PATCH/PUT /markers/1.json
  def update
    respond_to do |format|
      if @marker.update(marker_params)
        format.html { redirect_to @marker, notice: 'Marker was successfully updated.' }
        format.json { render :show, status: :ok, location: @marker }
      else
        format.html { render :edit }
        format.json { render json: @marker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /markers/1
  # DELETE /markers/1.json
  def destroy
    @marker.destroy
    respond_to do |format|
      format.html { redirect_to markers_url, notice: 'Marker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

	def pointinfo
	end

  def getMissionMarkers
    markers = []
    markers = Marker.where(mission_id: params[:mission_id])
    render json: markers.to_json
  end

  def mission_panel
    @mission=Mission.find(params[:mission_id])
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_marker
      @marker = Marker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def marker_params
      params.require(:marker).permit(:latitude, :longitude, :datetime, :mission_id, :mtype, :name)
    end
end
