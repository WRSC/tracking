$(document).ready(function(){
	$("#score_missions_dropdown").on("change", function () {
			var sv=$("#score_missions_dropdown option:selected").val()
			if (sv==0){//no mission
				alert('Pleas choose a mission')
			}else{
				requestRenderAttempts(sv)
			
			}
	});
})

function requestRenderAttempts(m_id){
	$.ajax({
		type: "GET",
		url: "/newAttemptinfo",
		data: {mission_id: m_id},

		success: function(){
			$("#score_attempt_dropdown").on("change", function () {
				var selv=$("#score_attempt_dropdown option:selected").val()
				if (selv==0){//no mission
					alert('Pleas choose an attempt')
				}else{
					requestRenderScoreinfo(selv)	
				}
			});
		}       
	});
}

function requestRenderScoreinfo(a_id)	{
	//alert('render score')
	$.ajax({
		type: "GET",
		url: "/newScoreinfo",
		data: {attempt_id: a_id},

		success: function(){
				$("#cal-timecost").click(function(){
					$("#score_timecost").prop("readonly", true);
					requestCalculateTimecost(a_id)
				})
		}       
	});
}

function requestCalculateTimecost(a_id)	{
	$.ajax({
		type: "GET",
		url: "/calculateTimecost",
		data: {attempt_id: a_id},

		success: function(data){
			$("#score_timecost").val(data)
			$("#score_timecost").css("border", "2px solid red");
// calculate rawscore for stationkeeping
			$("#cal-rawscore-stationkeeping").click(function(){
					$("#cal-rawscore-stationkeeping").prop("readonly", true);
					
					requestCalculateRawscore(a_id,data)
			})
		}       
	});
}

function requestCalculateRawscore(a_id,timecost){
	$.ajax({
		type: "GET",
		url: "/calculateRawscore",
		data: {attempt_id: a_id, timecost: timecost},

		success: function(data){
			$("#score_rawscore").val(data)
			$("#score_rawscore").css("border", "2px solid red");
		}       
	});
	
}

