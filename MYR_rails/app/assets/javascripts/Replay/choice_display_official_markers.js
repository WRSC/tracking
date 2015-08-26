var markerDisplay=false

function setMarkerDisplay(x){
  markerDisplay=x
}

function getMarkerDisplay(){
  return markerDisplay
}

function displayMarkersOrnot(){
	//--------------INITIALIZATION-------------------------------------------------
	var needDisplay=false
	$( "input[name='display-official-markers']" ).each(function () {
	  var id = $(this).attr('id');
	  var str = $.cookie("displayOM");//display Official Markers
	  if (str!=null){
	     buoyDisplay = str;
	  }
	  else{
	     buoyDisplay='false';
	  }
		if (buoyDisplay=='true'){	 
	    $(this).prop('checked',true);
	  }
	  else{
	    $(this).prop('checked',false);
	  }
	})
	//initial display of the page
	//if at least one checkbox is checked
	$( "input[name='display-official-markers']").each(function () { 
 	  if($(this).is(':checked')){
       needDisplay=true
     }
    setMarkerDisplay(needDisplay)
 	})

//-------------------  ACTIONS OF THE CHECKBOXE -------------------------------
//pour toutes les checkboxes
  $( "input[name='display-official-markers']"  ).each(function () { 
    //si on clique dessus
    $(this).click(function() {
      //alert('changed')
      //récupére l'id de la checkbox
      var id = $(this).attr('id');
      //si coché
      if($(this).is(':checked')){
		    $.cookie("displayOM",'true');//display Official Markersa
        needDisplay=true
      }else{//si décoché
		    $.cookie("displayOM",'false');//display Official Markers
        needDisplay=false
      }
      setMarkerDisplay(needDisplay)
    })
  })
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









