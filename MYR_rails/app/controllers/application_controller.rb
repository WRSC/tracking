class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session


  include SessionsHelper
  include TeamsHelper
	include SimpleCaptcha::ControllerHelpers

  protected

  # check if psw correct and the role is administrator with no arguments
  def authenticate
    authenticate_or_request_with_http_basic do |name, password|
      if m=Member.find_by_name(name) 
        if (m.authenticate(password) && m.role == "administrator")
		  true
		else
		  false
		end
      else
        false
      end
    end
	name=""
	password=""
  end
  
  # check if psw correct and the role is administrator with arguments
  def authenticatebis(name, password)
    if m=Member.find_by_name(name) 
    	if (m.authenticate(password))
			  true
			else
			  return -1
			end
  	else
    	return -2
    end
  end
  
  # Check if the user is a leader, or an admin
  def authenticateA_L
    authenticate_or_request_with_http_basic do |name, password|
      if m=Member.find_by_name(name) 
        if (m.authenticate(password) )
			if m.id == cookies.signed[:user_id]
				if (Member.find_by_id(cookies.signed[:user_id]).role == "administrator" || is_leader?)
					true
				else
					false
				end
			else
				false
			end
		else
		  false
		end
      else
        false
      end
    end
  end

    # check if the user is the team leader or admin through arg
  def authenticateA_L2(nameTeam)
	rep=false
	m=Team.find_by_name(nameTeam)
	if is_leader(m.name) 
		rep=true
	elsif (is_admin?)
		rep = true
	end
	return rep
  end
  

  # check if the user is admin thanks to cooky
  def authenticateA
    if is_admin?
      true
    else
      authenticate_or_request_with_http_basic do |name, password|
        if m=Member.find_by_name(name) 
          if (m.authenticate(password) && (m.id == current_user.id))
      			if(is_admin?)
      				true
      			else
      				false
  			     end
  		    else
  		      false
  		    end
        else
          false
        end
      end
    end
  end

  # check if the user is in the team or admin thanks to cooky
  def authenticateA_M
    authenticate_or_request_with_http_basic do |name, password|
      if m=Member.find_by_name(name) 
        if (m.authenticate(password) && (m.id == cookies.signed[:user_id]))
			if(isInTeam? || is_admin?)
				true
			else
				false
			end
		else
		  false
		end
      else
        false
      end
    end
  end

  # check if the user is in the team or admin through arg
  def authenticateA_M2(nameTeam)
	  if m=Team.find_by_name(name) 
		if(isInTeam? || is_admin?)
			if ((m.id == myTeam.id)|| is_admin?)
				true
			else
				false
			end
		else
		  false
		end
	  else
		false
	  end
  end


    # check if authenticated
  def authenticateA_P
    authenticate_or_request_with_http_basic do |name, password|
      if m=Member.find_by_name(name) 
        if (m.authenticate(password) && (m.id == cookies.signed[:user_id]))
		  true
		else
		  false
		end
      else
        false
      end
    end
  end
   
    # check if the user is authenticated or admin through arg
  def authenticateA_P2(myMember)
	rep=false
	m=Member.find_by_name(myMember.name)
	if m != nil
		if (m.id == cookies.signed[:user_id] )
			rep=true
		elsif (is_admin?)
			rep = true
		end
	end
	return rep
  end

  #used for redirecting to an incorrect url
end
