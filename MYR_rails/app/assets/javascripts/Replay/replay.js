//=require Replay/replay_map
//=require Replay/choice_teams
//=require Replay/choice_editions
//=require Replay/choice_robots
//=require Replay/choice_onerobot
//=require Replay/handle_markers_replay
//=require Replay/choice_options

/*====================official markers=====================*/
//=require Replay/choice_display_official_markers
//=require Replay/officialMarkers


//need to check, when we did not change the option, but click the button update, it will display the initial page of google map and then reload the desired page

//need to check if we need to remeber choosing missions and attempts
//need to check if we need a ajax request for displaying a infowindow

//need to check chose start and end time to display all coordiantes
$(document).ready(function(){
	//initialization
	google.maps.event.addDomListener(window, 'load', initializeMap());
	//initializeMap();
	initialScroll();
	wantInfo();
	wantDoReplay();
  	displayMarkersOrnot();
  	requestRefreshTeams();

	$("#dropdown_select_mission").change(update_visible_teams);
	$("#updatebutton").click(update_displayed_traces);
});


//-----------------------------------------------------------------
	
	function requestRefreshTeams(){
		/*=========================Begin choose teams and robots================================*/
		//choose teams <= choose robots <= choose mission <= choose attemps
		$.ajax({
			type: "GET",
			url: "/choice_teams",
			success: function(){
				run_choice_teams();
			}       
		});
	}

	/*===================End Choose teams and robots============================*/

function update_visible_teams() {
	// Hide and uncheck all attempts
	$('.attempts-list li').hide();
	$('.attempts-list li input[type=checkbox]').prop('checked', false);

	// Show attempts for the selected mission
	var selected_mission = $('#dropdown_select_mission :selected').val();
	$('.attempts-list li[data-mission-id="' + selected_mission + '"]').show();
}

function update_displayed_traces() {
	clearMap();

	var checked = $('.attempts-list input:checked');
	var attempts = checked.map(function(i, elt) {
		return {
			tracker: parseInt(elt.dataset.trackerId),
			start: elt.dataset.attemptStart,
			end: elt.dataset.attemptEnd,
		};
	}).get();
	console.log(attempts);
	attempts.forEach(function(a) {
		requestCoordsForAttempt(a.start, a.end, a.tracker);
	})
}

function requestCoordsForAttempt(tstart,tend,tracker_id) {
	$.ajax({
		type: "GET",
		url: "/gatherCoordsBetweenDates",
		data: {tstart : tstart, tend: tend, trackers: tracker_id},
		dataType: "json",
		success: function(data){
			refreshWithNewMarkers2(data);
			// if (getShowInfo()){
			// 	requestWantInfo();
			// }
		}
	});
}
