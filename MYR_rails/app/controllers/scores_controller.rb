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

	before_action :share_triangular_params, only:[:triangular, :triangularsailboat, :triangularmicrosailboat]
	before_action :share_stationkeeping_params, only:[:stationkeeping, :stationkeepingsailboat, :stationkeepingmicrosailboat]
	before_action :share_race_params, only:[:race, :racesailboat, :racemicrosailboat]


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
#=============== new page ====================
  	def new
  		#@score = Score.new
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
#=====================================================
	
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
#bestTriangularscore => timecost
						if rob.bestTriangularscoreId==nil || Score.find_by_id(rob.bestTriangularscoreId).timecost > @score.timecost
							rob.update_attribute(:bestTriangularscoreId, @score.id) 
							rob.update_attribute(:bestTriangulartime, @score.timecost) 
						end
					when "StationKeeping"
						if rob.bestStationscoreId==nil || Score.find_by_id(rob.bestStationscoreId).rawscore < @score.rawscore 
							rob.update_attribute(:bestStationscoreId, @score.id) 
							rob.update_attribute(:bestStationscore, @score.rawscore) 
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
	

	def finalstanding
	end
  
#======================== triangular ===========================================
	def triangular
	end

	def triangularsailboat
		flag=params[:flag]
		if flag=="true"
#ranking		
			firstrobots=Mission.where(mtype: "TriangularCourse")[0].robots.where(category: "Sailboat").order(:bestTriangulartime).uniq
			#should make sure bestTriangulartime is not nil
			@robots=[]
			firstrobots.each do |rob|
				if rob.bestTriangulartime!=nil
					@robots.push(rob)
				end
			end
			for rank in 0..(@robots.length-1)
				@robots[rank].update_attribute(:triangularRank, rank+1)	
				s=Score.find_by_id(@robots[rank].bestTriangularscoreId)
				s.update_attribute(:rawscore, (11-rank > 4 ?  11-rank : 4))	
				#			
			end
		end
	end
	
	def triangularmicrosailboat
	end

#=========================== station keeping ==================================
	def stationkeeping
	end


	def stationkeepingsailboat
		flag=params[:flag]
		if flag=="true"
#ranking		
			firstrobots=Mission.where(mtype: "StationKeeping")[0].robots.where(category: "Sailboat").order(bestStationscore: :desc).uniq
			@robots=[]
			firstrobots.each do |rob|
				if rob.bestStationscore != nil
					@robots.push(rob)
				end
			end
			for rank in 0..(@robots.length-1)
				@robots[rank].update_attribute(:stationRank, rank+1)			
			end
		end
	end

	def stationkeepingmicrosailboat
		flag=params[:flag]
		if flag=="true"
#ranking		
			@robots=Mission.where(mtype: "StationKeeping")[0].robots.where(category: "MicroSailboat").order(bestscore: :desc).uniq
			for rank in 0..(@robots.length-1)
				@robots[rank].update_attribute(:stationRank, rank+1)			
			end
		end
	end
#============================ area scanning ======================================
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

#============================= fleet race ============================================
	def fleetrace
	end
	
	def racesailboat
	end

	def racemicrosailboat
	end
  	
#=================================== private functions ==================================
 	private
		def share_triangular_params
			get_rob_by_category
			@m=Mission.where(mtype: "TriangularCourse")[0]
			# make sure the mission mtype is TriangularCourse
			sail_ids=[]
			@sailboatlist.each do |rob|
				sail_ids.push(rob.id)		
			end	
			m_id=@m.id
			@sail_atts=Attempt.where(mission_id: m_id).where(robot_id: sail_ids)		
			@sail_scores=[]
			@sail_atts.each do |a|
				if a.score != nil
					@sail_scores.push(a.score)
				end
			end

			microsail_ids=[]
			@microSailboatlist.each do |rob|
				microsail_ids.push(rob.id)		
			end
			@microsail_atts=Attempt.where(mission_id: m_id).where(robot_id: microsail_ids)	
			@microsail_scores=[]
			@microsail_atts.each do |a|
				@microsail_scores.push(a.score)
			end
		end

		def share_stationkeeping_params
			get_rob_by_category
			# make sure the mission mtype is StaionKeeping
			@m=Mission.where(mtype: "StationKeeping")[0]
			sail_ids=[]
			@sailboatlist.each do |rob|
				sail_ids.push(rob.id)		
			end	
			m_id=@m.id
			@sail_atts=Attempt.where(mission_id: m_id).where(robot_id: sail_ids)		
			@sail_scores=[]
			@sail_atts.each do |a|
				if a.score != nil
					@sail_scores.push(a.score)
				end
			end

			microsail_ids=[]
			@microSailboatlist.each do |rob|
				microsail_ids.push(rob.id)		
			end
			@microsail_atts=Attempt.where(mission_id: m_id).where(robot_id: microsail_ids)	
			@microsail_scores=[]
			@microsail_atts.each do |a|
				if a.score != nil
					@microsail_scores.push(a.score)
				end
			end
		end

		def share_race_params
			get_rob_by_category
			@m=Mission.where(mtype: "Race")[0]
			# make sure the mission mtype is TriangularCourse
			sail_ids=[]
			@sailboatlist.each do |rob|
				sail_ids.push(rob.id)		
			end	
			m_id=@m.id
			@sail_atts=Attempt.where(mission_id: m_id).where(robot_id: sail_ids)		
			@sail_scores=[]
			@sail_atts.each do |a|
				if a.score != nil
					@sail_scores.push(a.score)
				end
			end

			microsail_ids=[]
			@microSailboatlist.each do |rob|
				microsail_ids.push(rob.id)		
			end
			@microsail_atts=Attempt.where(mission_id: m_id).where(robot_id: microsail_ids)	
			@microsail_scores=[]
			@microsail_atts.each do |a|
				@microsail_scores.push(a.score)
			end
		end

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
