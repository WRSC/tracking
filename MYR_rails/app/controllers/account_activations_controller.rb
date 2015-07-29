class AccountActivationsController < ApplicationController

	def show
	end
	
  def edit
    user = Member.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      sign_in user
      flash[:success] = "Account activated!"
      respond_to do |format|
        format.html { redirect_to user, notice: 'Your account has been activated ! You can now look at the competition in the Real Time or the Replay pages. Or if you are a competitor, create or join your team ! If you need more information, consult the help page.' }
        format.json { head :no_content  }
      end
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end

end
