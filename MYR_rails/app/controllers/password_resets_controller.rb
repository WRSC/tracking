class PasswordResetsController < ApplicationController

 before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
before_action :check_expiration, only: [:edit, :update]


  def new

  end
	

  def edit
	
  end
  
  def create
    @member = Member.find_by(email: params[:password_reset][:email].downcase)
    if @member
      @member.create_reset_digest
      @member.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to '/password_resets/sent_password_reset_email'
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

	def update
		  if params[:member][:password].empty?
      flash.now[:danger] = "Password can't be empty"
      render 'edit'
    elsif @member.update_attributes(member_params)
      sign_in @member
      flash[:success] = "Password has been reset."
      redirect_to @member
    else
      render 'edit'
    end
	end
  
  def sent_password_reset_email
  end

	private

		 def member_params
      params.require(:member).permit(:password, :password_confirmation)
    end

    def get_user
      @member = Member.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@member && @member.activated? &&
              @member.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

		def check_expiration
      if @member.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
  
end
