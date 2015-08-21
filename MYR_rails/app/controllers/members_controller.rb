#https://github.com/galetahub/simple-captcha/pull/39/files
class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy, :create, :wait_for_activated]
  

  # GET /members
  # GET /members.json
  def index
    @members = Member.all
  end

  # GET /members/1
  # GET /members/1.json
  def show
  	@member = Member.find_by_id(params[:id]) 
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
  end

  # POST /members
  # POST /members.json
  def create
		if simple_captcha_valid?
		  if params[:member][:role] != "administrator" || (sign_in? && is_admin?)
		  	
		    @member = Member.new(member_params)

		    #respond_to do |format|
		      if @member.save
		        #sign_in(@member)
		        @member.send_activation_email
		   			flash[:info] = "Please check your email to activate your account."
		    		redirect_to '/account_activations/wait_for_activated'
		        #format.html { redirect_to @member, notice: 'Member was successfully created.' }
		        #format.json { render :show, status: :created, location: @member }
		      else
		        #format.html { render :new }
		        #format.json { render json: @member.errors, status: :unprocessable_entity }
		        render 'new'
		      end
		    #end
		  else
		    flash[:error] = "Ask an administrator for becoming administrator"
		    redirect_to '/members/new'
		  end
		else
			flash[:info] = "Captcha Invalid"
			redirect_to '/members/new'
		end
  end


  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    if sign_in?
      if authenticateA_P2(current_user)
        @member = Member.find(params[:id])
        if params[:member][:role] != "administrator" || (sign_in? && is_admin?)
          respond_to do |format|
            if @member.update(member_params)
              format.html { redirect_to @member, notice: 'Member was successfully updated.' }
              format.json { render :show, status: :ok, location: @member }
            else
              format.html { render :edit }
              format.json { render json: @member.errors, status: :unprocessable_entity }
            end
          end
        else
          flash.now[:error] = "Ask an administrator for becoming administrator"
        end
      else
        flash.now[:error] = "You can not modify this Account: "+@member.name
      end
    else
      flash[:error] = "You are not connected, you have to Sign in or Sign up"
    end
  end
  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    if sign_in?
      if authenticateA_P2(current_user)
        @member = Member.find(params[:id])
        if (heIsLeader?(@member.name))
          for m in Member.where(team: @member.team)
            m.update(:team => nil)
          end
          @team=Team.find_by_leader_id(@member.id)
          @robots = Robot.where(team_id: @team.id)
          @robots.each do |rob|
            rob.destroy
          end
          @team.destroy
        end
        if !is_admin?
          sign_out
        end
        @member.destroy
        respond_to do |format|
          format.html { redirect_to members_url, notice: 'Member was successfully destroyed.' }
          format.json { head :no_content }
        end
      else
        flash[:error] = "You can not delete this Account: "+@member.name
        respond_to do |format|
          format.html { redirect_to members_url, notice: 'You can not delete this Account: '+@member.name}
          format.json { head :no_content }
        end
      end
    else
      flash[:error] = "You are not connected, you have to Sign in or Sign up"
      respond_to do |format|
        format.html { redirect_to @member, notice: 'You are not connected, you have to Sign in or Sign up'}
        format.json { render :show }
      end
    end
  end
  


  def invite
    if sign_in?
      if is_leader?
        @member = Member.find(params[:id])
        @member.update_attribute(:team, current_user.team)
        flash[:succes] = "Invitation sent !"
      end
    end
    # respond_to do |format|
    #   format.html { redirect_to members_url }
    #   format.json { head :no_content }
    # end
    # if cookies[:playerInvite] != nil && cookies[:playerInvite] != ""
    #   if heIsInTeam?(cookies[:playerInvite]) == false
    #     myVar=Member.find_by_name(cookies[:playerInvite])
    #     if myVar.role != "administrator"
    #       myVar.update(:team_id => current_user.team_id)
    #       cookies.delete(:playerInvite)
    #     end
    #   end
    # end
  end

  def kick
      @member = Member.find(params[:id])
      @member.update_attribute(:team, nil)
  end  

  def leave
      @member = Member.find(params[:id])
      @member.update_attribute(:team, nil)
      respond_to do |format|
        format.html {redirect_to :back, notice: 'You left your team.' }
        format.json {render inline: "location.reload();" }
      end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_member
  	if @member && @member.activated
   		@member = Member.find(params[:id])
   	end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    params.require(:member).permit(:name, :password, :password_confirmation, :email, :role, :logo)
  end
end
