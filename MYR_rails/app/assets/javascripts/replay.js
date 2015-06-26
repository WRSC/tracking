//=require replay_map
//=require choice_robots
//=require choice_teams
var map
$(document).ready(function(){
	//initialization
	google.maps.event.addDomListener(window, 'load', initializeMap(map));

	//display panel
	//need to check $("#refresh-replay_panel").click();

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
