 $("#updatebutton").click(function() {
 	$.ajax({
 		type: "GET",
 		url: "/gatherCoords",
 		data: "datetime="+getLastDatetime(),
 		dataType: "json",
 		success: function(data){
 			if(data.length > 0){
 				refreshWithNewMarkers(data);
 			}
 		}       
 	});
 	if ($('#map-canvas').is(':offscreen')){
 		initialScroll();
 	}
 });

$(document).ready(function(){
  $("#updatebutton").click();
 })