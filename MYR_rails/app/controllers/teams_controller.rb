class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)
    user = Member.find_by_id(current_user.id)
    @team.leader_id = user.id
    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
    user.team_id = @team.id
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    if sign_in?
      if authenticateA_P2(@member)
        if params[:member][:role] != "administrator" || (sign_in? && is_admin?)
          respond_to do |format|
            if @team.update(team_params)
              format.html { redirect_to @team, notice: 'Team was successfully updated.' }
              format.json { render :show, status: :ok, location: @team }
            else
              format.html { render :edit }
              format.json { render json: @team.errors, status: :unprocessable_entity }
            end
          end
        else
          flash.now[:error] = "Ask an administrator for becoming administrator"
          render 'edit'
        end
      else
        flash.now[:error] = "You can not modify this Account: "+@member.name
        render 'edit'
      end
    else
      flash.now[:error] = "You are not connected, you have to Signin or Signup"
      render 'edit'
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name, :logo, :description, :leader_id)
    end
end
