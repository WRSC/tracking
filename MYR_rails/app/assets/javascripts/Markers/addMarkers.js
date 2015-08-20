function addPLP(){
//check if we had selected the mission 
	//alert($("#marker_missions_dropdown option:selected").val())
		choose_mission_markers()//choose mission
		/*============== Points ================*/
		$("#buoy-fix").click(function(){
			addFixBuoy()
		})	
		$("#buoy-draggable").click(function(){
			addDraggableBuoy()
		})	
		$("#saveBuoy").click(function(){
			saveBuoyMarker()
		})	
		/*============== Lines ================*/
		$("#polyline-fix").click(function(){
			addFixPolyline()
		})
		$("#polyline-custom").click(function(){
			addCustomPolyline()
		})
		$("#saveLine").click(function(){
			saveLineMarker()
		})	
		/*============== Polygons ================*/
		$("#polygon-fix").click(function(){
			addFixPolygon()
		})
		$("#polygon-custom").click(function(){
			addCustomPolygon()
		})
		$("#savePolygon").click(function(){
			savePolygonMarker()
		})	
		/*============= Circles =================*/
		$("#circle-fix").click(function(){
			addFixCircle()
		})
		$("#circle-custom").click(function(){
			addCustomCircle()
		})
		$("#saveCircle").click(function(){
			saveCircleMarker()
		})	
}






