function displayMarkersOrnot(){
	alert("enter display")
	//--------------INITIALIZATION-------------------------------------------------
	var count=0
	$(document).ready(function(){
		//initialize the checkboxs
		// FOR NOW => si pas de cookie -> rien n est coché
		$( "input[name='display-official-markers']" ).each(function () {

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
  $( "input[name='display-official-markers']"  ).each(function () { 
    //si on clique dessus
    $(this).click(function() {
      alert('changed')
      //récupére l'id de la checkbox
      var id = $(this).attr('id');
      //si coché
      if($(this).is(':checked')){
		    $.cookie("displayOM",'true');//display Official Markersa
        requestOfficialMarkersInfo()
      }else{//si décoché
		    $.cookie("displayOM",'false');//display Official Markers
      }
     	//need to do, when we choose teams, need to Emphasize
    })
  })
  requestOfficialMarkersInfo()
}

function requestOfficialMarkersInfo(){
	$.ajax({
		type: "GET",
		url: "/officialMarkersInfo",
	
		success: function(data){
	  	drawOfficialMarkers(data)
    }     
	})  
}








