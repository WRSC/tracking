// for the info windows check box

function wantInfo(tstart,tend,singleAttempt){
	$(document).ready(function(){
		$("#disp_info").each(function(){
	    	if($(this).is(':checked')){
	     		setShowInfo(false);
	    		$(this).prop('checked',false);
	     	}else{//si décoché
	     		setShowInfo(false);
	      	}
		});
	});

	$("#disp_info").click(function(){
    	if($(this).is(':checked')){
     		setShowInfo(true);
     		if (latest_markers[0].length > 0){
     			displayInfoWindow(tstart,tend,singleAttempt)
     		}
     	}else{//si décoché
      		setShowInfo(false);
      		if (latest_markers[0].length > 0){
      			hideInfoWindow()
      		}	
      	}
	});
}

function requestWantInfo(tstart,tend,singleAttempt){
    //if (latest_markers.length > 0){
   		displayInfoWindow(tstart,tend,singleAttempt)
    //}
}

function requestHideInfo(tstart,tend,singleAttempt){
    //if (latest_markers.length > 0){
   		hideInfoWindow()
    //}
}

function wantDoReplay(){
	$(document).ready(function(){
		$("#do_replay").each(function(){
	    	if($(this).is(':checked')){
	    		$(this).prop('checked',false);
	     		setDoReplay(false);
	     	}else{//si décoché
	      		setDoReplay(false);
	      	}
		});
	});

	$("#do_replay").click(function(){
    	if($(this).is(':checked')){
    		alert("show me from the beginning !")
     		setDoReplay(true);
     	}else{//si décoché
      		setDoReplay(false);
      	}
	});
}