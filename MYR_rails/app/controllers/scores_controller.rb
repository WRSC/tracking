class ScoresController < ApplicationController
	include ScoreHelper

	before_action :set_score, only: [:edit, :show, :update, :destroy]
	before_action :get_rob_by_category, only:[:triangular, :stationkeeping, :areascanning, :fleetrace, :finalstanding]

  	def index
			@teamlist=Team.all
			@TMission = Mission.where(mtype: "TriangularCourse")
			@RMission = Mission.where(mtype: "Race")
			@SKMission = Mission.where(mtype: "StationKeeping")
			@ASMission = Mission.where(mtype: "AreaScanning")
			@scores=Score.all
  	end

  	def show
  		@score=Score.find(params[:id])
  	end

  	def new
  		@score = Score.new
  	end
	
		def edit
			@score=Score.find(params[:id])
		end

		# POSt /scores
  	def create
	    @score = Score.new(score_params)
	    respond_to do |format|
	      if @score.save
	        format.html { redirect_to @score, notice: 'Score was successfully created.' }
	        format.json { render :show, status: :created, location: @score }
	      else
	        format.html { render :new }
	        format.json { render json: @score.errors, status: :unprocessable_entity }
	      end
	    end
  	end

  	def update
	    respond_to do |format|
	      if @score.update(score_params)
	        format.html { redirect_to @score, notice: 'score was successfully updated.' }
	        format.json { render :show, status: :ok, location: @score }
	      else
	        format.html { render :edit }
	        format.json { render json: @score.errors, status: :unprocessable_entity }
	      end
	    end
  end

  def destroy
	    @score.destroy
	    respond_to do |format|
	      format.html { redirect_to missions_url, notice: 'score was successfully destroyed.' }
	      format.json { head :no_content }
	    end
  end
	
	def newAttemptinfo
		m_id=params[:mission_id]
		@attempts=Mission.find_by_id(m_id).attempts
	end

	def newScoreinfo
		@a_id=params[:attempt_id]
	end
	
	def calculateScore
		a_id=params[:attempt_id]
		render json: getScorebyAttemptId(a_id)
	end

	def finalstanding
	end
  
	def triangular
		# make sure the mission 1 is triangular
		sail_ids=[]
		@sailboatlist.each do |rob|
			sail_ids.push(rob.id)		
		end
		@sail_atts=Attempt.where(mission_id: 1).where(robot_id: sail_ids)		
		microsail_ids=[]
		@microSailboatlist.each do |rob|
			microsail_ids.push(rob.id)		
		end
		@microsail_atts=Attempt.where(mission_id: 1).where(robot_id: microsail_ids)	
		
	end

	def stationkeeping
		# make sure the mission 2 is stationkeeping
		sail_ids=[]
		@sailboatlist.each do |rob|
			sail_ids.push(rob.id)		
		end
		@sail_atts=Attempt.where(mission_id: 2).where(robot_id: sail_ids)		
		microsail_ids=[]
		@microSailboatlist.each do |rob|
			microsail_ids.push(rob.id)		
		end
		@microsail_atts=Attempt.where(mission_id: 2).where(robot_id: microsail_ids)	
		
	end

  def areascanning
		# make sure the mission 3 is areascanning
		sail_ids=[]
		@sailboatlist.each do |rob|
			sail_ids.push(rob.id)		
		end
		@sail_atts=Attempt.where(mission_id: 3).where(robot_id: sail_ids)		
		microsail_ids=[]
		@microSailboatlist.each do |rob|
			microsail_ids.push(rob.id)		
		end
		@microsail_atts=Attempt.where(mission_id: 3).where(robot_id: microsail_ids)	
		
  end

	def fleetrace
		# make sure the mission 4 is fleetrace
		sail_ids=[]
		@sailboatlist.each do |rob|
			sail_ids.push(rob.id)		
		end
		@sail_atts=Attempt.where(mission_id: 4).where(robot_id: sail_ids)		
		microsail_ids=[]
		@microSailboatlist.each do |rob|
			microsail_ids.push(rob.id)		
		end
		@microsail_atts=Attempt.where(mission_id: 4).where(robot_id: microsail_ids)
	end
  	
 	private
		def get_rob_by_category
			@sailboatlist=Robot.where(category: "Sailboat")
			@microSailboatlist=Robot.where(category: "MicroSailboat")
		end

    # Use callbacks to share common setup or constraints between actions.
    def set_score
      @score = Score.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def score_params
      params.require(:score).permit(:attempt_id, :timecost, :rawscore, :penalty, :penalty_description, :datetimes)
    end
end
