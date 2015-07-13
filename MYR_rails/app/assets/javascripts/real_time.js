//=require rtmap
//=require handle_markers
//=require autorefresh
//=require rt_print_buoys

var map
$(document).ready(function(){
	//initialization
	google.maps.event.addDomListener(window, 'load', initializeMap());
	$("#refresh-panel").click();
	$("#options-panel-bis").click();

	AR_checkbox_cookie();
	dispBuoys_checkbox_cookie();

	//initializeMap();
	initialScroll();
});

	

/*=========================== Begin select a mission==================================*/
function choosetMission(){
		missions=getAllCurrentMissions();
		nbmissions=missions.length
		if (nbmissions >1){
			var e = $('#dropdown_select_mission :selected').val();
			if (e=="select_mission"){
				alert("Please choose a correct mission!!!")
			}else{
				saveCurrentMission(e)
			}

			//alert(getCurrentMission())//just for debugger
		}
		$("#robots-panel-bis").click();
		loadMissionBuoys();
		displayMissionsBuoys();
		manual_or_auto_refresh();
			
}

function selectMissions(){
	$("#map-panel").on("click", "#chooseMission", function() {
		$.ajax({
				type: "GET",
				url: "/getMissions",
				success: function(data){// retrieve an array containing the not yet known trackers
					if(data.length > 0){
						eraseMap();
						if (myReset!= null){
      						clearInterval(myReset);
      					}
						setAllCurrentMissions(data);
						choosetMission();
						$.ajax({
							type: "GET",
							url: "/robots_panel",
							success: function(data){// retrieve an array containing the not yet known trackers
							}       
						});

					}
				}       
			});
	})

}
/*============================End select a mission=========================================*/

//when the panel is displayed
$("#map-panel").ready(function(){
	selectMissions()


	
  //for all checkboxes of tracker, on click do ...
  $("#map-panel").on("click", "input[name*='tracker']", function() {
      //get id of the checkbox
      var id = $(this).attr('id');
      //if checked
      if($(this).is(':checked')){
      	saveNewDesiredTracker(id);
      }
      //if not checked
      else{
      	removeDesiredTracker(id);
      } 

    })

});



	/*
	$("#getCoordinatesForCurrentMission").click(function(){
		$.ajax({
			type: "GET",
			url: "/getMissionLength",
			dataType: "json",
			success: function(data){
				if(data.length > 0){
					start = data[0];
					end = data[1];
					$.ajax({
						type: "GET",
						url: "/gatherCoordsBetweenDates",
						dataType: "json",
						data: { tstart: start, tend: end},
						success: function(data){
							if(data.length > 0){
								length = data.length;
								refreshWithNewMarkers(data);
							}
						}       
					});
				}
			}       
		});
	});
*/

//-----------------------------------------------------------------
