module ApplicationHelper
  include ConstantDefault
  def li_actif(myPachList)
	rep = "<li>".html_safe
	if myPachList.class == Array
		for myPach in myPachList
			if request.original_fullpath == myPach
				rep = "<li class=\"active\">".html_safe
			end
		end
	elsif myPachList.class == String
		if request.original_fullpath == myPachList
			rep = "<li class=\"active\">".html_safe
		end
	end
	return rep
  end 
  
end
