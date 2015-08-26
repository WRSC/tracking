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
	before_action :get_rob_by_category, only:[:triangular, :stationkeeping, :areascanning, :fleetrace, :index]
	before_action :share_score_with_ajax, only: [:newAttemptinfo,:newScoreinfo,:calculateScore,:new]

	before_action :share_triangular_params, only:[:triangular, :triangularsailboat, :triangularmicrosailboat]
	before_action :share_stationkeeping_params, only:[:stationkeeping, :stationkeepingsailboat, :stationkeepingmicrosailboat]
	before_action :share_areascanning_params, only:[:areascanning, :areascanningsailboat, :areascanningmicrosailboat]
	before_action :share_race_params, only:[:race, :racesailboat, :racemicrosailboat]
	

  	def index
			@teamlist=Team.all
			
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

		# POST /scores
  	def create
	    @score = Score.new(score_params)
#humanintervention timecost=-10
			if @score.timepenalty != nil
				@score.timecost=@score.timecost*(1+@score.timepenalty)
			end
	    respond_to do |format|
	      if @score.save
# compare current score with best score and update the information
# need to add th penalty
					rob=@score.attempt.robot
					case @score.attempt.mission.mtype
#===================== case triangular ==========================================
					when "TriangularCourse"
#bestTriangularscore => timecost
						if rob.bestTriangularscoreId==nil 
							rob.update_attribute(:bestTriangularscoreId, @score.id) 
							rob.update_attribute(:bestTriangulartime, @score.timecost) 
						else
							if @score.humanintervention != 1
								if Score.find_by_id(rob.bestTriangularscoreId).humanintervention==1 || @score.timecost < rob.bestTriangulartime
										rob.update_attribute(:bestTriangularscoreId, @score.id) 
										rob.update_attribute(:bestTriangulartime, @score.timecost) 
								end
							end
						end
#======================= case station keeping ===============================
					when "StationKeeping"
						if rob.bestStationscoreId==nil 
							rob.update_attribute(:bestStationscoreId, @score.id) 
							rob.update_attribute(:bestStationscore, @score.rawscore) 
						else
							if @score.humanintervention != 1
								if Score.find_by_id(rob.bestStationscoreId).humanintervention==1 || @score.rawscore > rob.bestStationscore
										rob.update_attribute(:bestStationscoreId, @score.id) 
										rob.update_attribute(:bestStationscore, @score.rawscore) 
								end
							end
						end
#====================== case area scanning ============================
					when "AreaScanning"
						p=-1
						if  @score.humanintervention != 1
							if @score.pointpenalty!=nil
								p=@score.pointpenalty
							else
								p=0
							end
							@score.update_attribute(:finalscore, @score.rawscore-p) 
						else
							@score.update_attribute(:finalscore, 0.0) 
					  end
								

						if rob.bestAreascoreId==nil
							rob.update_attribute(:bestAreascoreId, @score.id) 
							rob.update_attribute(:bestAreascore, @score.finalscore) 
						else
							if @score.humanintervention != 1
								if @score.finalscore > rob.bestAreascore
										rob.update_attribute(:bestAreascoreId, @score.id) 
										rob.update_attribute(:bestAreascore, @score.finalscore) 
								end
							end
						end
#====================== case fleet race ===============================
					when "Race"
						if rob.bestRacescoreId==nil 
							rob.update_attribute(:bestRacescoreId, @score.id) 
							rob.update_attribute(:bestRacetime, @score.timecost) 
						else
							if @score.humanintervention!=1
								if Score.find_by_id(rob.bestRacescoreId).humanintervention==1 || @score.timecost < rob.bestRacetime
										rob.update_attribute(:bestRacescoreId, @score.id) 
										rob.update_attribute(:bestRacetime, @score.timecost) 
								end
							end
						end
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
	
  
#======================== triangular ===========================================
	def triangular
	end

	def triangularsailboat
		flag=params[:flag]
		if flag=="true"
#ranking		
			firstrobots=Mission.where(mtype: "TriangularCourse")[0].robots.where(category: "Sailboat").order(:bestTriangulartime).uniq
			noHi=[]
			yesHi=[]
			notPaticipated=[]
			firstrobots.each do |r|
				if r.bestTriangularscoreId !=nil
					if Score.find_by_id(r.bestTriangularscoreId).humanintervention == 1
						yesHi.push(r)
					else
						noHi.push(r)				
					end
				else
					notPaticipated.push(r)
				end
			end
			
			
			for rank in 0..(noHi.length-1)
				noHi[rank].update_attribute(:triangularRank, rank+1)	
				s=Score.find_by_id(noHi[rank].bestTriangularscoreId)
				s.update_attribute(:rawscore, (10-rank > 4 ?  10-rank : 4))	
			end
			rank=noHi.length
			yesHi.each do |r|
				r.update_attribute(:triangularRank, rank+1)
				s=Score.find_by_id(r.bestTriangularscoreId)
				s.update_attribute(:rawscore, 0)	
			end
			notPaticipated.each do |r|
				r.update_attribute(:triangularRank, 0)	
				s=Score.find_by_id(r.bestTriangularscoreId)
				s.update_attribute(:rawscore, -1)	
			end
		end
	end
	
	def triangularmicrosailboat
		flag=params[:flag]
		if flag=="true"
#ranking		
			firstrobots=Mission.where(mtype: "TriangularCourse")[0].robots.where(category: "MicroSailboat").order(:bestTriangulartime).uniq
			noHi=[]
			yesHi=[]
			notPaticipated=[]
			firstrobots.each do |r|
				if r.bestTriangularscoreId !=nil
					if Score.find_by_id(r.bestTriangularscoreId).humanintervention == 1
						yesHi.push(r)
					else
						noHi.push(r)				
					end
				else
					notPaticipated.push(r)
				end
			end
			
			
			for rank in 0..(noHi.length-1)
				noHi[rank].update_attribute(:triangularRank, rank+1)	
				s=Score.find_by_id(noHi[rank].bestTriangularscoreId)
				s.update_attribute(:rawscore, (10-rank > 4 ?  10-rank : 4))	
			end
			rank=noHi.length
			yesHi.each do |r|
				r.update_attribute(:triangularRank, rank+1)
				s=Score.find_by_id(r.bestTriangularscoreId)
				s.update_attribute(:rawscore, 0)	
			end
			notPaticipated.each do |r|
				r.update_attribute(:triangularRank, 0)	
				s=Score.find_by_id(r.bestTriangularscoreId)
				s.update_attribute(:rawscore, -1)	
			end
		end
	end

#=========================== station keeping ==================================
	def stationkeeping
	end


	def stationkeepingsailboat
		flag=params[:flag]
		if flag=="true"
#ranking		
			#firstrobots=Mission.where(mtype: "TriangularCourse")[0].robots.where(category: "Sailboat").order(:bestTriangulartime).uniq
			firstrobots=Mission.where(mtype: "StationKeeping")[0].robots.where(category: "Sailboat").order(bestStationscore: :desc).uniq
			noHi=[]
			yesHi=[]
			notPaticipated=[]
			firstrobots.each do |r|
				if r.bestStationscoreId !=nil
					if Score.find_by_id(r.bestStationscoreId).humanintervention == 1
						yesHi.push(r)
					else
						noHi.push(r)				
					end
				else
					notPaticipated.push(r)
				end
			end
			
			for rank in 0..(noHi.length-1)
				noHi[rank].update_attribute(:stationRank, rank+1)	
	
			end
			rank=noHi.length
			yesHi.each do |r|
				r.update_attribute(:stationRank, rank+1)
			end
			notPaticipated.each do |r|
				r.update_attribute(:stationRank, 0)	
			end
		end
	end

	def stationkeepingmicrosailboat
		flag=params[:flag]
		if flag=="true"
#ranking		
			#firstrobots=Mission.where(mtype: "TriangularCourse")[0].robots.where(category: "Sailboat").order(:bestTriangulartime).uniq
			firstrobots=Mission.where(mtype: "StationKeeping")[0].robots.where(category: "MicroSailboat").order(:bestStationscore).uniq
			noHi=[]
			yesHi=[]
			notPaticipated=[]
			firstrobots.each do |r|
				if r.bestStationscoreId !=nil
					if Score.find_by_id(r.bestStationscoreId).humanintervention == 1
						yesHi.push(r)
					else
						noHi.push(r)				
					end
				else
					notPaticipated.push(r)
				end
			end
			
			for rank in 0..(noHi.length-1)
				noHi[rank].update_attribute(:stationRank, rank+1)	
	
			end
			rank=noHi.length
			yesHi.each do |r|
				r.update_attribute(:stationRank, rank+1)
			end
			notPaticipated.each do |r|
				r.update_attribute(:stationRank, 0)	
			end
		end
	end
#============================ area scanning ======================================
  def areascanning
  end

	def areascanningsailboat
		flag=params[:flag]
		if flag=="true"
#ranking		
		firstrobots=Mission.where(mtype: "AreaScanning")[0].robots.where(category: "Sailboat").order(bestAreascore: :desc).uniq
			robots=[]
			notPaticipated=[]
			firstrobots.each do |r|
				if r.bestAreascoreId !=nil
					robots.push(r)
				else
					notPaticipated.push(r)
				end
			end
			
			for rank in 0..(robots.length-1)
				robots[rank].update_attribute(:areaRank, rank+1)	
			end
			rank=robots.length
			notPaticipated.each do |r|
				r.update_attribute(:areaRank, 0)	
			end
		end
	end

	def areascanningmicrosailboat
			flag=params[:flag]
		if flag=="true"
#ranking		
		firstrobots=Mission.where(mtype: "AreaScanning")[0].robots.where(category: "MicroSailboat").order(bestAreascore: :desc).uniq
			robots=[]
			notPaticipated=[]
			firstrobots.each do |r|
				if r.bestAreascoreId !=nil
					robots.push(r)
				else
					notPaticipated.push(r)
				end
			end
			
			for rank in 0..(robots.length-1)
				robots[rank].update_attribute(:areaRank, rank+1)	
			end
			rank=robots.length
			notPaticipated.each do |r|
				r.update_attribute(:areaRank, 0)	
			end
		end
	end

#============================= fleet race ==========================================
	def fleetrace
	end
	
	def racesailboat
		flag=params[:flag]
		if flag=="true"
#ranking		
			firstrobots=Mission.where(mtype: "Race")[0].robots.where(category: "Sailboat").order(:bestRacetime).uniq
			noHi=[]
			yesHi=[]
			notPaticipated=[]
			firstrobots.each do |r|
				if r.bestRacescoreId !=nil
					if Score.find_by_id(r.bestRacescoreId).humanintervention == 1
						yesHi.push(r)
					else
						noHi.push(r)				
					end
				else
					notPaticipated.push(r)
				end
			end
			
			for rank in 0..(noHi.length-1)
				noHi[rank].update_attribute(:raceRank, rank+1)	
				s=Score.find_by_id(noHi[rank].bestRacescoreId)
				note= (16-rank > 2 ?  16-rank : 2)
				if s.marginten == 1
					note > 5 ? note=note : note=5
				end
				s.update_attribute(:finalscore,note)	
			end
			rank=noHi.length
			yesHi.each do |r|
				r.update_attribute(:raceRank, rank+1)
				s=Score.find_by_id(r.bestRacescoreId)
				s.update_attribute(:finalscore, 0)	
			end
			notPaticipated.each do |r|
				r.update_attribute(:raceRank, 0)	
				s=Score.find_by_id(r.bestRacescoreId)
				s.update_attribute(:finalscore, -1)	
			end
		end
	end

	def racemicrosailboat
		flag=params[:flag]
		if flag=="true"
#ranking		
			firstrobots=Mission.where(mtype: "Race")[0].robots.where(category: "MicroSailboat").order(:bestRacetime).uniq
			noHi=[]
			yesHi=[]
			notPaticipated=[]
			firstrobots.each do |r|
				if r.bestRacescoreId !=nil
					if Score.find_by_id(r.bestRacescoreId).humanintervention == 1
						yesHi.push(r)
					else
						noHi.push(r)				
					end
				else
					notPaticipated.push(r)
				end
			end
			
			for rank in 0..(noHi.length-1)
				noHi[rank].update_attribute(:raceRank, rank+1)	
				s=Score.find_by_id(noHi[rank].bestRacescoreId)
				s.update_attribute(:rawscore, (10-rank > 4 ?  10-rank : 4))	
			end
			rank=noHi.length
			yesHi.each do |r|
				r.update_attribute(:raceRank, rank+1)
				s=Score.find_by_id(r.bestRacescoreId)
				s.update_attribute(:rawscore, 0)	
			end
			notPaticipated.each do |r|
				r.update_attribute(:raceRank, 0)	
				s=Score.find_by_id(r.bestRacescoreId)
				s.update_attribute(:rawscore, -1)	
			end
		end
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
	
		def share_areascanning_params
			get_rob_by_category
			@m=Mission.where(mtype: "AreaScanning")[0]
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
      params.require(:score).permit(:attempt_id, :timecost, :rawscore, :humanintervention, :AIS, :datetimes, :pointpenalty,:pointpenalty_description, :timepenalty
, :timepenalty_description, :marginten)
    end
end
