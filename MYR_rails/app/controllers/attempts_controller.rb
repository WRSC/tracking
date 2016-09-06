class AttemptsController < ApplicationController
	include ScoreHelper
  before_action :set_attempt, only: [ :show, :edit, :update, :destroy]
	
	
  # GET /attempts
  # GET /attempts.json
  def index
    @attempts = Attempt.all
  end

  # GET /attempts/1
  # GET /attempts/1.json
  def show
  end

  # GET /attempts/new
  def new
    @attempt = Attempt.new
  end

  # GET /attempts/1/edit
  def edit
  end

  # POST /attempts
  # POST /attempts.json
  def create
    @attempt = Attempt.new(attempt_params)

    respond_to do |format|
      if @attempt.save
        format.html { redirect_to @attempt, notice: 'Attempt was successfully created.' }
        format.json { render :show, status: :created, location: @attempt }
      else
        format.html { render :new }
        format.json { render json: @attempt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attempts/1
  # PATCH/PUT /attempts/1.json
  def update
    respond_to do |format|
      if @attempt.update(attempt_params)
        format.html { redirect_to @attempt, notice: 'Attempt was successfully updated.' }
        format.json { render :show, status: :ok, location: @attempt }
      else
        format.html { render :edit }
        format.json { render json: @attempt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attempts/1
  # DELETE /attempts/1.json
  def destroy
    @attempt.destroy
    respond_to do |format|
      format.html { redirect_to attempts_url, notice: 'Attempt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

	# get uploadXMLAS
	def uploadXMLAS
		@a=Attempt.find_by_id(attempt_params[:uploadxml_a_id])
	end
	
	# post uploadXMLAS
	def updateXMLAS
		a=Attempt.find_by_id(attempt_params[:uploadxml_a_id])
		#render json: attempt_params[:uploadxml].original_filename

		a.update(uploadxml: attempt_params[:uploadxml])
		a.update(upload_timestamp: attempt_params[:upload_timestamp])
		if a.save
			redirect_to a.robot
		else
			redirect_to "/404"
		end
	end

# get uploadJsonAS
	def uploadJsonAS
		@a=Attempt.find_by_id(attempt_params[:uploadxml_a_id])
	end

# post uploadJsonAS
	def updateJsonAS
		a=Attempt.find_by_id(attempt_params[:uploadxml_a_id])
		#render json: attempt_params[:uploadxml].original_filename

		a.update(uploadjson: attempt_params[:uploadjson])
		
		if a.save
			redirect_to a.robot
		else
			redirect_to "/404"
		end
	end

	def generateXMLfile
		@a=Attempt.find_by_id(params[:uploadxml_a_id])
		#inputname=a.uploadxml.file.original_filename
		input=@a.uploadjson.file.file.split("/").last

		#filetab=file.split("/")
		#inputname=filetab.last
		#render json: file
		done=loadJsonDataAreaScanning(input)

		@a.update_attribute(:generated_filename,done)
	end

  def export
      #selectionner les coordonnées dans la plage de temps
      mesDateTimes=[]
      nbptsmax=100000
      mesDateTimes=[@attempt.start,@attempt.end]
      myTrackerId = @attempt.tracker_id
 

      if mesDateTimes != nil && mesDateTimes != [] && myTrackerId != nil
        if sign_A?
          if myTrackerId == 0
            allCoordinate=Coordinate.where(datetime: mesDateTimes[0]..mesDateTimes[1]).order(datetime: :asc)
          else
            allCoordinate=Coordinate.where(datetime: mesDateTimes[0]..mesDateTimes[1]).where(tracker_id: myTrackerId).order(datetime: :asc)
          end
          @data = allCoordinate
        else
          @data = []
        end
      end


      respond_to do |format|
        format.html { redirect_to root_url }
        format.csv { send_data @data.to_csv }
      end
    end

  private
	
    # Use callbacks to share common setup or constraints between actions.
    def set_attempt
      @attempt = Attempt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attempt_params
      params.require(:attempt).permit(:name, :start, :end, :robot_id, :mission_id, :tracker_id, :uploadxml,:uploadjson, :uploadxml_a_id, :upload_timestamp)
    end
end
