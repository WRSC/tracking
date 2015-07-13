//=require Replay/replay_map
//=require Replay/choice_teams
//=require Replay/choice_robots
//=require Replay/choice_onerobot
//=require ../Markers/handle_markers_replay


//need to check, when we did not change the option, but click the button update, it will display the initial page of google map and then reload the desired page
//need to check, when choose >1 time attempts, the adaptzoom need to fix

$(document).ready(function(){
	//initialization
	google.maps.event.addDomListener(window, 'load', initializeMap());
	//initializeMap();
	initialScroll();
	requestRefreshTeams();

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
