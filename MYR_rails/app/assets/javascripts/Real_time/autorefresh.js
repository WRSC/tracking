// Js handling the autorefresh option or the manual option

// Supposed to memorize the state of the check box
function AR_checkbox_cookie(){
	$("input[id='aRCB']").each(function(){
		  var id = $(this).attr('id');
		  var str = $.cookie("autorefresh");
		  //index de l'élément à retirer
		  if(str > 0){
		    $(this).prop('checked',true);
		  }
		  else{
		    $(this).prop('checked',false);
		  }
  	});
}



function manual_or_auto_refresh(){	

// If the checkbox is checked before using the call of function, this will run the function associated
	$("input[id='aRCB']").each(function(){
		if($(this).is(':checked')){
        	autoUpdate()
       	}else{//si décoché
       		if (myReset!= null){
      			clearInterval(myReset);
      		}
        	updateMap()
		}
	});


// Detect the click on the check box
	$("#aRCB").click(function(){
      if($(this).is(':checked')){
        autoUpdate()
        myReset = setInterval(function() {
					getNewTrackersAuto();
				}, getRefreshRate());
        $.cookie("autorefresh",1);
      }else{//si décoché
      	if (myReset!= null){
      		alert("Stopping autorefresh")
      		clearInterval(myReset);
      	}
        updateMap()
		$.cookie("autorefresh",0);
      }
	});

	// detect the value of the drop down menu for the maximum number of coordinates loaded 

	$("#dropdown_select_maxCoords").each(function(){
		var state = $('#dropdown_select_maxCoords :selected').val();
		setMaxCoords(state);
	})

	$("#dropdown_select_maxCoords").change(function(){
		var state = $('#dropdown_select_maxCoords :selected').val();
		setMaxCoords(state);
	})

	// detect the value of the drop down menu for refrest rate

	$("#dropdown_select_refreshRate").each(function(){
		var state = $('#dropdown_select_refreshRate :selected').val();
		if (state<5000){
			alert("/!\\WARNING/!\\\r\nUsing a high refresh rate (below 5s)\r\nmay reduce the performance of the server\r\nand cause bugs.")
		}
		setRefrestRate(state);
	})

	$("#dropdown_select_refreshRate").change(function(){
		var state = $('#dropdown_select_refreshRate :selected').val();
		if (state<5000){
			alert("/!\\WARNING/!\\\r\nUsing a high refresh rate (below 5s)\r\nmay reduce the performance of the server\r\nand cause bugs.")
		}
		setRefrestRate(state);
		if (myReset!= null){
      		clearInterval(myReset);
      	}
      	myReset = setInterval(function() {
					getNewTrackersAuto();
				}, getRefreshRate());
	})

	// detect the value of the drop down menue for the latest coordinates loaded

	$("#dropdown_select_offset").each(function(){
		var state = $('#dropdown_select_offset :selected').val();
		setOffset(state);
	})

	$("#dropdown_select_offset").change(function(){
		var state = $('#dropdown_select_offset :selected').val();
		setOffset(state);
		saveLastDatetime("10000101");
	})





}

//--------------------------------------------------------------------------------------------------
	//gather newly added coordinates or add coordinates since begining of mission
function getNewCoordinates(){
	//$("#getNewCoordinates").click( function() {
		$.ajax({
			type: "GET",
			url: "/gatherCoordsSince",
			data: {datetime : getLastDatetime(), trackers: getDesiredTrackers(), mission_id: getCurrentMission(), numCoords: getMaxCoords(), offset: getOffset()},
			dataType: "json",
			success: function(data){
				if(data.length > 0){
					refreshWithNewMarkers2(data,getMyMap());
					//clearDesiredTrackers(getDesiredTrackers()); //need to check
				}
			}       
		});
	//});
}

function getNewTrackers(){
	// for testing, replace the button refresh by two buttons one for getting the trackers, one for getting the coordinates afterwards
	//$("#getNewTrackers").click(function() {
		$("#requestRefresh").click(function() {
		$.ajax({
			type: "GET",
			url: "/getNewTrackers",
			data: {datetime : getLastDatetime(), trackers: getKnownTrackers(), mission_id: getCurrentMission(), numCoords: getMaxCoords(), offset: getOffset()}, //!!!!! Be careful, datetime can not begin with 0
			dataType: "json",
			success: function(data){// retrieve an array containing the not yet known trackers
				if(data.length > 0){
					saveNewDesiredTracker(data);
					saveNewKnownTracker(data);
					loadMissionRobots();
					//alert("Received data: "+data);
				}
				getNewCoordinates();
			}       
		});
	});
}

function getNewCoordinatesAuto(){
		$.ajax({
			type: "GET",
			url: "/gatherCoordsSince",
			data: {datetime : getLastDatetime(), trackers: getDesiredTrackers(), mission_id: getCurrentMission(), numCoords: getMaxCoords(), offset: getOffset()},
			dataType: "json",
			success: function(data){
				if(data.length > 0){
					refreshWithNewMarkers2(data,getMyMap());
					if(first_launch){
						myReset = setInterval(function() {
						getNewTrackersAuto();
						}, getRefreshRate());
						first_launch=false;
					}
				}
			}       
		});
}
// not sure but
//getNewCoordinatesAuto is used in getNewTrackersAuto because somehow getNewCoordinatesAuto don't find the trackers otherwise
function getNewTrackersAuto(){
		$.ajax({
			type: "GET",
			url: "/getNewTrackers",
			data: {datetime : getLastDatetime(), trackers: getKnownTrackers(), mission_id: getCurrentMission(), numCoords: getMaxCoords(), offset: getOffset()}, //!!!!! Be careful, datetime can not begin with 0
			dataType: "json",
			success: function(data){// retrieve an array containing the not yet known trackers
				if(data.length > 0){
					saveNewDesiredTracker(data)//need to check???? need to clear when finish
					saveNewKnownTracker(data);
					loadMissionRobots();
				}
				getNewCoordinatesAuto();
			}       
		});
}

function updateMap(){
		$.ajax({
			type: "GET",
			url: "/update_map",
			data: {mission_id: getCurrentMission()},
			
			success: function(){
				getNewTrackers();
				getNewCoordinates();
			}       
		});
}



function autoUpdate(){
		$.ajax({
			type: "GET",
			url: "/update_map_auto",
			data: {mission_id: getCurrentMission()},
			
			success: function(){
				getNewTrackersAuto();
			}       
		});
}

/*function requestManageDispRobot(){
	$.ajax({
		type: "GET",
		url: "/manageDispRobot",
		
		success: function(){
			alert($.cookie("robotslist"));
			
		}       
	});
}*/