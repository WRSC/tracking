function addPLP(){
//check if we had selected the mission 
	//alert($("#marker_missions_dropdown option:selected").val())
	if ($("#marker_missions_dropdown option:selected").val()==0){
		alert('Please choose a mission before you continue')
	}else{
		$("#AddBuoy").click(function(){
			
			addBuoy(60.103462, 19.928225)
		})	
		$("#AddLine").click(function(){
			addLine()
		})
		$("#AddPolygon").click(function(){
			addPolygon()
		})
	}
}




