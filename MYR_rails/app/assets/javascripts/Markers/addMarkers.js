function addPLP(){
//check if we had selected the mission 
	//alert($("#marker_missions_dropdown option:selected").val())
		/*============== Points ================*/
		$("#buoy-fix").click(function(){
			addFixBuoy()
		})	
		$("#buoy-draggable").click(function(){
			addDraggableBuoy()
		})	
		
		/*============== Lines ================*/
		$("#polyline-fix").click(function(){
			addFixPolyline()
		})
		
		$("#polyline-custom").click(function(){
			addCustomPolyline()
		})
		
		/*============== Polygons ================*/
		$("#polygon-fix").click(function(){
			addFixPolygon()
		})
		$("#polygon-custom").click(function(){
			addCustomPolygon()
		})
	
}




