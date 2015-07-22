function loadMissionRobots(){
				$.ajax({
					type: "GET",
					url: "/robots_panel",
					data: {trackers: getDesiredTrackers(), mission_id: getCurrentMission()},
					success: function(){
						display_robots();
					}       
				});
			}

function display_robots(){
	$(document).ready(function(){
		  //initialize the checkboxs
		// FOR NOW => si pas de cookie -> rien n est coché
		$( "input[name='All']" ).each(function () {
			$(this).prop('checked',true);
			$( "input[name*='robot']" ).each(function () {
			 	var id = $(this).attr('id');
			    $(this).prop('checked',true);
			    //requestShowRobot(true,id);
			})

		 	$(this).click(function(){
		 		if (isAllRobotChecked()){
		 			$( "input[name*='robot']" ).each(function () {
	   					//on clique dessus si pas coche
	    				$(this).click();
	    			})
    			}
    			else{
    				$( "input[name*='robot']" ).each(function () {
	   					//on clique dessus si pas coche
						if($(this).is(':checked')){ 
	    				}
	    				else{
	    					$(this).click();
	    				}
	    			})		
    			}
    		})
		})   
		/*$( "input[name*='robot']" ).each(function () {
			var id = $(this).attr('id');
			var str = $.cookie("robotslist");
			if (str!= null){
				var tab = str.split(",");
		    	//index de l'élément à retirer
		   		 var index = tab.indexOf(id);
			}
			else {
				var index = -1;
			}
		    if(index > -1){
		      	$(this).prop('checked',true);
		      	requestShowRobot(true,id);
		    }
		    else{
		      	$(this).prop('checked',false);
		        requestHideRobot(true,id);
		    }
		})*/
	})

//-------------------  ACTIONS OF THE CHECKBOXES -------------------------------
//pour toutes les checkboxes
  $( "input[name*='robot']" ).each(function () {
  	$(this).prop('checked',true);
    //si on clique dessus
    $(this).click(function() {
      //récupére l'id de la checkbox
      var id = $(this).attr('id');
      //si coché
      	if($(this).is(':checked')){
       		//addrobot(id);
        	requestShowRobot(true,id);
        	if (isAllRobotChecked()){
        		$( "input[name='All']" ).each(function () {
					$(this).prop('checked',true);
				})	
        	}
     	}
      	//si décoché
     	else{
     		//rmvrobot(id);
     	    requestHideRobot(true,id);
     	    $( "input[name='All']" ).each(function () {
				$(this).prop('checked',false);
			})
    	}
    })
  })  
}

function isAllRobotChecked(){
	ok = true;
	$( "input[name*='robot']" ).each(function () {
		if($(this).is(':checked')){
		}
		else{
			ok= false;
		}
	})
	return ok;
}

//-------------------------------------------------------------------------------
//----------------------------ADD AND REMOVE ROBOTS--------------------------------
function addrobot(id){
	var str = $.cookie("robotslist");
	if(isPresent(id,str) == true){
  }//do nothing
  else{
    //si le cookie est inexistant ou vide
    if($.cookie("robotslist") == null || $.cookie("robotslist") == ""){
    	$.cookie("robotslist",id);
    }
      //sinon ajout
      else{
      	$.cookie("robotslist",$.cookie("robotslist")+","+id);
      }
    }
  }

function rmvrobot(id){
  	var str = $.cookie("robotslist");
  	var tab = str.split(",");
  //index de l'élément à retirer
  var index = tab.indexOf(id);
  if(index > -1){
    //retirer élément
    tab.splice(index,1);
    res = tab.toString();
    $.cookie("robotslist",res);
  }
}
//-------------------------------------------------------------------------------

//-------------------------------------------------------------------------------
function isPresent(id,str){
	if (str == null || str == ""){
    return false; //absent
  }
  else{
  	var tab = str.split(",");
  	var index = tab.indexOf(id);
  	if(index > -1){
  		return true;
  	}
  	else{
  		return false;
  	}
  }
}
//-------------------------------------------------------------------------------

function requestShowRobot(flag,id){
	$.ajax({
		type: "GET",
		url: "/trackerOfRobot",
		data: {robot : id, mission_id: getCurrentMission()},
		success: function(data){
			if (flag){
				if(data.length>0){
					showTrackers(data);
				}
			}
		}       
	});
}

function requestHideRobot(flag,id){
	$.ajax({
		type: "GET",
		url: "/trackerOfRobot",
		data: {robot : id, mission_id: getCurrentMission()},
		success: function(data){
			if (flag){
				if(data.length>0){
					hideTrackers(data);
				}
			}
		}       
	});
}