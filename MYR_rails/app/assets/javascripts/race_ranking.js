$(document).ready(function(){
	requestRenderSailboatTable(false,true)
	requestRenderMicroSailboatTable(false,true)
	$("#ranking-race-sailboat").click(function(){
		//alert('clicked')
		requestRenderSailboatTable(true,false)
	})

	$("#ranking-race-microsailboat").click(function(){
		requestRenderMicroSailboatTable(true,false)
	})
})

function requestRenderSailboatTable(flag,isFirst){
	$.ajax({
		type: "GET",
		url: "/racesailboat",
		data: {flag: flag},
		success: function(){
			if (isFirst==false){
				sailtable.destroy();
			}
			sailtable=$('#datatable-score-race-sailboat').DataTable({
				paging: true
			});
		}       
	});
}

function requestRenderMicroSailboatTable(flag,isFirst){
	$.ajax({
		type: "GET",
		url: "/racemicrosailboat",
		data: {flag: flag},
		success: function(){
			if (isFirst==false){
				microsailtable.destroy();
			}
			microsailtable=$('#datatable-score-race-microsailboat').DataTable({
				paging: true
			});
		}       
	});
}
