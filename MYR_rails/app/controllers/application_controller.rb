class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  include SessionsHelper
  include TeamsHelper
  protected
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

  
end
