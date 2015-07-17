function addPLP(){
//check if we had selected the mission 
	//alert($("#marker_missions_dropdown option:selected").val())
		$("#buoy-fix").click(function(){
			addFixBuoy()
		})	
		$("#buoy-draggable").click(function(){
			addDraggableBuoy()
		})	
		$("#AddLine").click(function(){
			addLine()
		})
		$("#AddPolygon").click(function(){
			addPolygon()
		})
	
}




