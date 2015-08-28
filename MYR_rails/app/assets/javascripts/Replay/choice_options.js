// for the info windows check box

function wantInfo(){
	$(document).ready(function(){
		$("#disp_info").each(function(){
	     	setShowInfo(false);
	    	$(this).prop('checked',false);
		});
	});

	$("#disp_info").click(function(){
    	if($(this).is(':checked')){
     		setShowInfo(true);
     		if (latest_markers[0].length > 0){
     			displayInfoWindow()
     		}
     	}else{//si décoché
      		setShowInfo(false);
      		if (latest_markers[0].length > 0){
      			hideInfoWindow()
      		}	
      	}
	});
}

function requestWantInfo(){
    if (latest_markers[0].length > 0){
   		displayInfoWindow()
    }
}

function requestHideInfo(){
    if (latest_markers[0].length > 0){
   		hideInfoWindow()
    }
}

function wantDoReplay(){
	$(document).ready(function(){
		$("#do_replay").each(function(){
	    	$(this).prop('checked',false);
	     	setDoReplay(false);
		});
	});

	$("#do_replay").click(function(){
    	if($(this).is(':checked')){
     		setDoReplay(true);
     		setFirstLaunch(true);
     	}else{//si décoché
     		if (myReset!= null){
	      		clearInterval(myReset);
      		}
      		setDoReplay(false);
      		setFirstLaunch(false);
      		alert("You need to click on the update button to load a new map.")
      	}
	});
}