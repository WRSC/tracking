class ScoresController < ApplicationController
  def index
		@teamlist=Team.all
  end
	
	def test
	end
  
end
