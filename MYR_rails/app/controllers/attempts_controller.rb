class AttemptsController < ApplicationController
  before_action :set_attempt, only: [:show, :edit, :update, :destroy]

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

	def uploadXMLAS
	end
	
	def updateXMLAS
		a=Attempt.find_by_id(attempt_params[:id])
		a.update(uploadxml: attempt_params[:uploadxml])
		if a.save
			redirect_to root_path
		else
			redirect_to root_path
		end
		
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attempt
      @attempt = Attempt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attempt_params
      params.require(:attempt).permit(:id, :name, :start, :end, :robot_id, :mission_id, :tracker_id,:uploadxml)
    end
end
