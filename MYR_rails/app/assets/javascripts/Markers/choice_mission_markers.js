function choose_mission_markers(){
	$.cookie("missions_marker",$("#marker_missions_dropdown option:selected").val());
	$("#marker_missions_dropdown").on("change", function () {
		$.cookie("missions_marker",$("#marker_missions_dropdown option:selected").val());
	});
}
