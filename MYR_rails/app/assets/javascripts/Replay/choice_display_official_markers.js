function displayMarkersOrnot(){
	alert("enter display")
	//--------------INITIALIZATION-------------------------------------------------
	var count=0
	$(document).ready(function(){
		//initialize the checkboxs
		// FOR NOW => si pas de cookie -> rien n est coché
		$( "input[name='display-official-markers']" ).(function () {

		  var id = $(this).attr('id');
		  var str = $.cookie("displayOM");//display Official Markers
		  if (str!=null){
		    var needDisplay = str;
		  }
		  else{
		     needDisplay='false';
		  }
			if (needDisplay=='true'){	 
		    $(this).prop('checked',true);
		  }
		  else{
		    $(this).prop('checked',false);
		  }
		})
		//initial display of the page
/*
		//if at least one checkbox is checked
		$( "input[name='display-official-markers']").(function () { 
  	  if($(this).is(':checked')){
  	    requestRefreshRobots();
  	  }
  	})
*/
	})
	
	
//-------------------  ACTIONS OF THE CHECKBOXE -------------------------------
//pour toutes les checkboxes
  $( "input[name='display-official-markers']"  ).(function () { 
    //si on clique dessus
    $(this).click(function() {
      //récupére l'id de la checkbox
      var id = $(this).attr('id');
      
      //si coché
      if($(this).is(':checked')){
        addteam(id);
        
      }else{//si décoché
        rmvteam(id);
        
      }
     
      requestRefreshRobots();
      
     	//need to do, when we choose teams, need to Emphasize
    })
  })  
}
