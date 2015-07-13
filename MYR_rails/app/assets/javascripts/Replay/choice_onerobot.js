
/*choose one robot*/
function requestRefreshOnerobot(flag){
	$.ajax({
		type: "GET",
		url: "/choice_onerobot",
	
		success: function(){
			if (flag){
				requestRefreshReplayMissions()
			}else{
				//if flag==false, it will not display choose mission
			}
		}       
	});
}

function requestRefreshReplayMissions(){
		$.ajax({
		type: "GET",
		url: "/choice_replay_missions",
		
		success: function(){
			choose_mission();
		}       
	});
}

function choose_mission(){
	$.cookie("missionslist",$("#replay_missions_dropdown option:selected").val());
	$("#replay_missions_dropdown").on("change", function () {
		$.cookie("missionslist",$("#replay_missions_dropdown option:selected").val());
		requestRefreshAttempts();
	});
}

function requestRefreshAttempts(){
	$.ajax({
		type: "GET",
		url: "/choice_attempts",
		
		success: function(){
			choose_attempts();
		}       
	});
}

function choose_attempts(){
	$.cookie("attemptslist",$("#attempts_dropdown option:selected").val());
	$("#attempts_dropdown").on("change", function () {
		$.cookie("attemptslist",$("#attempts_dropdown option:selected").val());
		requestRefreshUpdateButton(1);
	});
}

function requestRefreshUpdateButton(nb){
	$.ajax({
		type: "GET",
		url: "/update_replay_map",
		
		success: function(){
			$('#updatebutton').click(function(){
				initializeMap()
				if (nb==1)
					requestRefreshMapFromAttempt();
				else{
					if (nb==2){
						getDatetimesInfos()  //It was in the file choice_robots
					}
				}
			})
		}       
	});
}


function requestRefreshMapFromAttempt(){
	$.ajax({
		type: "GET",
		url: "/getSingleAttemptInfos",
		
		success: function(data){
			//alert(data)
			//tstart: data[0]; tend: data[1]; trackers: data[2] 

			requestGatherCoordsBetweenDates(data[0],data[1],data[2]);
		}       
	});
}

	
function requestGatherCoordsBetweenDates(tstart,tend,trackers){//desired_data contains start, end, tracker_id[]
	//alert(desired_data[2])

	
	//alert (trackers)
	$.ajax({
		type: "GET",
		url: "/gatherCoordsBetweenDates",
		data: {tstart : tstart, tend: tend, trackers: trackers},
		dataType: "json",
		success: function(data){
			refreshWithNewMarkers2(data,tstart,tend);
			
		}       
	});
}



