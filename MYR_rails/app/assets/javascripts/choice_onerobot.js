/*choose one robot*/
function requestRefreshOnerobot(){
		$.ajax({
		type: "GET",
		url: "/choice_onerobot",
		
		success: function(){
			requestRefreshReplayMissions()
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
	$.cookie("missionslist",$("#dropdown option:selected").val());
	$("#dropdown").on("change", function () {
		$.cookie("missionslist",$("#dropdown option:selected").val());
		choose_attempts();
	});
}

function choose_attempts(){

	$.ajax({
		type: "GET",
		url: "/choice_attempts",
		
		success: function(){
		}       
	});
}

//--------------------- TRIES --------------------------------------------------

$(document).ready(function () {
   $.cookie("rtrieslist","");
});

var c = 0;
$("#dropdown2").on("change", function () {
  $.cookie("rtrieslist",$("#dropdown2 option:selected").val());
  if (c==0){
  //quand on coche une checkbox pour la premiere fois
  $.cookie("rdatetimes","");//ne tiens plus compte du datetime
  $("#refreshupdate").click(); //affiche le champ update
  c=1;
  }
});




