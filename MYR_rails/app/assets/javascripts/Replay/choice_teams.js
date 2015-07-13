
function run_choice_teams(){
//--------------INITIALIZATION-------------------------------------------------
	var count=0
	$(document).ready(function(){
		//initialize the checkboxs
		// FOR NOW => si pas de cookie -> rien n est coché
		$( "input[name*='team']" ).each(function () {
		  var id = $(this).attr('id');
		  var str = $.cookie("teamslist");
		  if (str!=null){
		    var tab = str.split(",");
		  }
		  else{
		    tab=[];
		  }
		  //index de l'élément à retirer
		  var index = tab.indexOf(id);
		  if(index > -1){
		    $(this).prop('checked',true);
		  	count=count+1;
		  }
		  else{
		    $(this).prop('checked',false);
		  }
		})
		//initial display of the page
		//if at least one checkbox is checked
		$( "input[name*='team']" ).each(function () { 
  	  if($(this).is(':checked')){
  	    requestRefreshRobots();
  	  }
  	})
	})
		
//-------------------  ACTIONS OF THE CHECKBOXES -------------------------------
//pour toutes les checkboxes
  $( "input[name*='team']" ).each(function () { 
    //si on clique dessus
    $(this).click(function() {
      //récupére l'id de la checkbox
      var id = $(this).attr('id');
      
      //si coché
      if($(this).is(':checked')){
        addteam(id);
        count=count+1;
      }else{//si décoché
        rmvteam(id);
        count=count-1;
      }
     
      requestRefreshRobots();
      
     	//need to do, when we choose teams, need to Emphasize
    })
  })  
}

function requestRefreshRobots(){
		$.ajax({
		type: "GET",
		url: "/choice_robots",
		
		success: function(){
			run_choice_robots();
		}       
	});
}



//-------------------------------------------------------------------------------
//------------------------------CHOICE TEAMS---------------------------------------
//------------------------ ADD AND REMOVE TEAMS------------------------------------
function addteam(id){
	var str = $.cookie("teamslist");
	if(isPresent(id,str) == true){
  }//do nothing
  else{
    //si le cookie est inexistant ou vide
    if($.cookie("teamslist") == null || $.cookie("teamslist") == ""){
    	$.cookie("teamslist",id);
    }
    //sinon ajout
    else{
    	$.cookie("teamslist",$.cookie("teamslist")+","+id);
    	//alert('add team cookie');
    }
  }
}

  function rmvteam(id){
  	var str = $.cookie("teamslist");
  	var tab = str.split(",");
  //index de l'élément à retirer
  var index = tab.indexOf(id);
  if(index > -1){
    //retirer élément
    tab.splice(index,1);
    res = tab.toString();
    $.cookie("teamslist",res);
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


