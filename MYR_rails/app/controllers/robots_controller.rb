class RobotsController < ApplicationController
#https://richonrails.com/articles/allowing-file-uploads-with-carrierwave
  before_action :set_robot, only: [:show, :edit, :update, :destroy] 
	before_action :robotChart, only: [:set_robot]
  # GET /robots
  # GET /robots.json
  def index
    @robots = Robot.all
  end

  # GET /robots/1
  # GET /robots/1.json
  def show
		
  end

  # GET /robots/new
  def new
    @robot = Robot.new
  end

  # GET /robots/1/edit
  def edit
  end
	
	def robotChart
		data=[]
		rob=Robot.find_by_id(params[:id])
		data.push(rob)		
		missions=rob.missions
		data.push(missions)
		attempts=[]
		missions.each do |m|			
			attempts=m.attempts		
		end
		data.push(attempts)
		render json: data
	end

  # POST /robots
  # POST /robots.json
  def create
    if sign_in?
			if is_leaderById(params[:robot][:team_id]) || is_admin?
				allTrakersAvailable = [nil]+trackerAvailable
				if params[:robot][:tracker_id] == nil
					params[:robot][:tracker_id] = ""
				end
				if params[:robot][:tracker_id] == "" || is_admin?
					if allTrakersAvailable.include?(params[:robot][:tracker_id].to_i) == true || params[:robot][:tracker_id] == ""
					@robot = Robot.new(robot_params)
						respond_to do |format|
							if @robot.save
								format.html { redirect_to @robot, notice: 'Robot was successfully created.' }
								format.json { render :show, status: :created, location: @robot }
							else
								format.html { render :new }
								format.json { render json: @robot.errors, status: :unprocessable_entity }
							end
						end
					else
						flash[:error] = "This tracker is not available"
						redirect_to '/robots/new'
					end
				else
					flash[:error] = "Just an Admin can select a tracker"
					redirect_to '/robots/new'
				end
			else
				flash[:error] = "You need to be the team Leader of the team selected to create a robot"
				redirect_to '/robots/new'
			end
		else
			flash[:error] = "You are not connected, you have to Signin or Signup"
			redirect_to '/robots/new'
		end
  end

  # PATCH/PUT /robots/1
  # PATCH/PUT /robots/1.json
  def update
    respond_to do |format|
      if @robot.update(robot_params)
        format.html { redirect_to @robot, notice: 'Robot was successfully updated.' }
        format.json { render :show, status: :ok, location: @robot }
      else
        format.html { render :edit }
        format.json { render json: @robot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /robots/1
  # DELETE /robots/1.json
  def destroy
    @robot.destroy
    respond_to do |format|
      format.html { redirect_to robots_url, notice: 'Robot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_robot
      @robot = Robot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def robot_params
      params.require(:robot).permit(:name, :category, :team_id, :tracker_id)
    end
end
