$(document).ready(function(){
	requestRenderSailboatTable(false,true)
	requestRenderMicroSailboatTable(false,true)
	$("#ranking-staionkeeping-sailboat").click(function(){
		requestRenderSailboatTable(true,false)
	})
})

function requestRenderSailboatTable(flag,isFirst){
	$.ajax({
		type: "GET",
		url: "/stationkeepingsailboat",
		data: {flag: flag},
		success: function(){
			if (isFirst==false){
				sailtable.destroy();
			}
			sailtable=$('#datatable-score-stationkeeping-sailboat').DataTable({
				paging: true
			});
		}       
	});
}

function requestRenderMicroSailboatTable(flag,isFirst){
	$.ajax({
		type: "GET",
		url: "/stationkeepingmicrosailboat",
		data: {flag: flag},
		success: function(){
			if (isFirst==false){
				microsailtable.destroy();
			}
			microsailtable=$('#datatable-score-stationkeeping-microsailboat').DataTable({
				paging: true
			});
		}       
	});
}
