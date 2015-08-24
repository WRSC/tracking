class ScoresController < ApplicationController
	include ScoreHelper
=begin
	mtype of missions:
		TriangularCourse
		StationKeeping
		AreaScanning
		Race
=end

	before_action :set_score, only: [:edit, :show, :update, :destroy]
	before_action :get_rob_by_category, only:[:triangular, :stationkeeping, :areascanning, :fleetrace, :finalstanding]

	before_action :share_score_with_ajax, only: [:newAttemptinfo,:newScoreinfo,:calculateScore,:new]


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
  		#@score = Score.new
  	end
	
		def edit
			@score=Score.find(params[:id])
		end

		# POSt /scores
  	def create
	    @score = Score.new(score_params)
#humanintervention timecost=-10
			if @score.humanintervention==1
				@score.timecost=-10
				@score.rawscore=0			
			end
	    respond_to do |format|
	      if @score.save
# compare current score with best score and update the information
# need to add th penalty
					rob=@score.attempt.robot
					case @score.attempt.mission.mtype
					when "TriangularCourse"
						Score.find_by_id(rob.bestscoreId)
					when "StationKeeping"
						if rob.bestscoreId==nil || Score.find_by_id(rob.bestscoreId).rawscore < @score.rawscore 
							rob.update_attribute(:bestscoreId, @score.id) 
						end
					when "AreaScanning"
						
					when "Race"

					end
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
	      format.html { redirect_to scores_url, notice: 'score was successfully destroyed.' }
	      format.json { head :no_content }
	    end
  end
	
	def newAttemptinfo
		m_id=params[:mission_id]
		@allAttempts=Mission.find_by_id(m_id).attempts
		@attempts=[]
		@allAttempts.each do |a|
			if a.score==nil
				@attempts.push(a)
			end		
		end	
	end

	def newScoreinfo
		@a_id=params[:attempt_id]
		@mission=Attempt.find_by_id(@a_id).mission
	end
	
	def calculateTimecost
		a_id=params[:attempt_id]
		render json: getTimecostbyAttemptId(a_id)
	end
	
	def calculateRawscore
		timecost=params[:timecost].to_i
		render json:  stationKeepingRawScoreWithTimecost(timecost)
	end

	def finalstanding
	end
  
	def triangular
		# make sure the mission mtype is TriangularCourse
		sail_ids=[]
		@sailboatlist.each do |rob|
			sail_ids.push(rob.id)		
		end
		#sail_atts=Attempt.where(mtype: "TriangularCourse").where(robot_id: sail_ids)		
		m_id=Mission.where(mtype: "TriangularCourse")[0].id
		sail_atts=Attempt.where(mission_id: m_id).where(robot_id: sail_ids)		
		@sail_scores=[]
		sail_atts.each do |a|
			@sail_scores.push(a.score)
		end

		microsail_ids=[]
		@microSailboatlist.each do |rob|
			microsail_ids.push(rob.id)		
		end
		microsail_atts=Attempt.where(mission_id: m_id).where(robot_id: microsail_ids)	
		@microsail_scores=[]
		microsail_atts.each do |a|
			@microsail_scores.push(a.score)
		end
	end

	def stationkeeping
		# make sure the mission mtype is StaionKeeping
		@m=Mission.where(mtype: "StationKeeping")[0]
		sail_ids=[]
		@sailboatlist.each do |rob|
			sail_ids.push(rob.id)		
		end	
		m_id=@m.id
		sail_atts=Attempt.where(mission_id: m_id).where(robot_id: sail_ids)		
		@sail_scores=[]
		sail_atts.each do |a|
			if a.score != nil
				@sail_scores.push(a.score)
			end
		end

		microsail_ids=[]
		@microSailboatlist.each do |rob|
			microsail_ids.push(rob.id)		
		end
		microsail_atts=Attempt.where(mission_id: m_id).where(robot_id: microsail_ids)	
		@microsail_scores=[]
		microsail_atts.each do |a|
			@microsail_scores.push(a.score)
		end
	end

  def areascanning
	# make sure the mission mtype is AreaScanning
		sail_ids=[]
		@sailboatlist.each do |rob|
			sail_ids.push(rob.id)		
		end
			
		m_id=Mission.where(mtype: "AreaScanning")[0].id
		sail_atts=Attempt.where(mission_id: m_id).where(robot_id: sail_ids)		
		@sail_scores=[]
		sail_atts.each do |a|
			@sail_scores.push(a.score)
		end

		microsail_ids=[]
		@microSailboatlist.each do |rob|
			microsail_ids.push(rob.id)		
		end
		microsail_atts=Attempt.where(mission_id: m_id).where(robot_id: microsail_ids)	
		@microsail_scores=[]
		microsail_atts.each do |a|
			@microsail_scores.push(a.score)
		end
  end

	def fleetrace
	# make sure the mission mtype is Race
		sail_ids=[]
		@sailboatlist.each do |rob|
			sail_ids.push(rob.id)		
		end
		#sail_atts=Attempt.where(mtype: "TriangularCourse").where(robot_id: sail_ids)		
		m_id=Mission.where(mtype: "Race")[0].id
		sail_atts=Attempt.where(mission_id: m_id).where(robot_id: sail_ids)		
		@sail_scores=[]
		sail_atts.each do |a|
			@sail_scores.push(a.score)
		end

		microsail_ids=[]
		@microSailboatlist.each do |rob|
			microsail_ids.push(rob.id)		
		end
		microsail_atts=Attempt.where(mission_id: m_id).where(robot_id: microsail_ids)	
		@microsail_scores=[]
		microsail_atts.each do |a|
			@microsail_scores.push(a.score)
		end
	end
  	
 	private
		def share_score_with_ajax
			@score=Score.new
		end

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
      params.require(:score).permit(:attempt_id, :timecost, :rawscore, :humanintervention, :AIS, :datetimes)
    end
end
