//=require Markers/newmarker_map
//=require Markers/choice_mission_markers
//=require Markers/addMarkers
//=require Markers/Point
//=require Markers/Line
//=require Markers/Polygon
//=require Markers/Circle

//need to check adaptzoom

/*======variable global======*/
markers=[];

$(document).ready(function(){
	
	initializeMap();
	initialScroll();
	addPLP()//add points || lines || polygones

});
