//=require choice_onerobot

//-----------INITIALIZATION--------------------------------------------
function run_choice_robots(){
	var c=0
	$(document).ready(function(){
		var d = 0;
		  //initialize the checkboxs
		// FOR NOW => si pas de cookie -> rien n est coché
		$( "input[name*='robot']" ).each(function () {
		  var id = $(this).attr('id');
		  var str = $.cookie("robotslist");
		  var tab = str.split(",");
	    //index de l'élément à retirer
	    var index = tab.indexOf(id);
	    if(index > -1){
	      $(this).prop('checked',true);
	      c=c+1;
	    }
	    else{
	      $(this).prop('checked',false);
	    }
		})

		if (c==1){
				//quand on coche une checkbox pour la premiere fois
				requestRefreshOnerobot();//affiche le volet pour missions tries
		}else if (c > 1){
			requestRefreshDatetimes();
		}else{}
		
	})

//-------------------  ACTIONS OF THE CHECKBOXES -------------------------------
//pour toutes les checkboxes
  $( "input[name*='robot']" ).each(function () {
    //si on clique dessus
    $(this).click(function() {
      //récupére l'id de la checkbox
      var id = $(this).attr('id');
      //si coché
      if($(this).is(':checked')){
        addrobot(id);
        c=c+1;
      }
      //si décoché
      else{
        rmvrobot(id);
        c=c-1;
      }
      
			if (c==1){
				//quand on coche une checkbox pour la premiere fois
				requestRefreshOnerobot()//affiche le volet pour missions tries
			}else if (c > 1){
				requestRefreshDatetimes();
			}
			else{} 
    })
  })  
}

function requestRefreshDatetimes(){
		$.ajax({
		type: "GET",
		url: "/choice_datetimes",
		
		success: function(){
			//alert('choice datetimes')
		}       
	});
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
