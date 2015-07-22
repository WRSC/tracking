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
		
		/*============== Polygons ================*/
		$("#polygon-fix").click(function(){
			addFixPolygon()
		})
		$("#polygon-custom").click(function(){
			addCustomPolygon()
		})
		
		/*============= Circles =================*/
		$("#circle-fix").click(function(){
			addFixCircle()
		})
		$("#circle-custom").click(function(){
			addCustomCircle()
		})
		
	
}




