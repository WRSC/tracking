class ScoresController < ApplicationController
	include ScoreHelper

  	def index
		@teamlist=Team.all
  	end
	
	def test
	end
  
  	def show
  		@score=Score.find(params[:id])
  	end

  	def new
  		@score = Score.new
  	end

  	def create

	    attempt = Attempt.find(params[:score][:attempt_id])
	    mission = Mission.find(attempt.mission_id)

	    
	    
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
  	
  	 private
    # Use callbacks to share common setup or constraints between actions.
    def set_score
      @score = Score.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def score_params
      params.require(:score).permit(:attempt_id)
    end
end