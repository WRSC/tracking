class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :edit, :update, :destroy]
	
  # GET /sessions/new
  def new
    @titre = "Identification"
  end

  # POST /sessions
  # POST /sessions.json
  def create
=begin
    @session = Sessions.new(session_params)

    respond_to do |format|
      if @session.save
        format.html { redirect_to @session, notice: 'Sessions was successfully created.' }
        format.json { render :show, status: :created, location: @session }
      else
        format.html { render :new }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
=end
	user = Member.find_by_name(params[:session][:name])
  flag = authenticatebis(params[:session][:name], params[:session][:password])
  if flag == true
  	if user.activated?
			sign_in(Member.find_by_name(params[:session][:name]))
			params[:session][:remember_me] == '1' ? remember(user) : forget(user)
			#flash[:success] = params[:session][:name]+" is connected"
			redirect_back_or user
		else
			 message  = "Account not activated. "
       message += "Check your email for the activation link."
       flash[:warning] = message
       redirect_to root_url
		end

  elsif flag==-1
    flash.now[:error] = "Invalid Password."
    @titre = "Identification"
    render 'new'
    
  else
    flash.now[:error] = "Invalid Name."
    @titre = "Identification"
    render 'new'
  
  end
  
  end


  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def delete
  #flash[:success] = Member.find_by_id(cookies.signed[:user_id]).name+" is disconnect"
    sign_out if sign_in?
  	redirect_to '/home'
  end

end
