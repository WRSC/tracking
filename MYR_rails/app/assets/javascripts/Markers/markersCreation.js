//=require Markers/newmarker_map
//=require Markers/choice_mission_markers
//=require Markers/addMarkers
//=require Markers/Point
//=require Markers/Line
//=require Markers/Polygon

/*======variable global======*/
markers=[];

$(document).ready(function(){
	
	initializeMap();
	initialScroll();
	choose_mission_markers();

});
