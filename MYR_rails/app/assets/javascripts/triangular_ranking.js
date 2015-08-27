$(document).ready(function(){
	requestRenderSailboatTable(false,true)
	requestRenderMicroSailboatTable(false,true)
	$("#ranking-triangular-sailboat").click(function(){
		//alert('clicked')
		requestRenderSailboatTable(true,false)
	})

	$("#ranking-triangular-microsailboat").click(function(){
		requestRenderMicroSailboatTable(true,false)
	})
})

function requestRenderSailboatTable(flag,isFirst){
	$.ajax({
		type: "GET",
		url: "/triangularsailboat",
		data: {flag: flag},
		success: function(){
			if (isFirst==false){
				sailtable.destroy();
			}
			sailtable=$('#datatable-score-triangular-sailboat').DataTable({
				paging: true
			});
		}       
	});
}

function requestRenderMicroSailboatTable(flag,isFirst){
	$.ajax({
		type: "GET",
		url: "/triangularmicrosailboat",
		data: {flag: flag},
		success: function(){
			if (isFirst==false){
				microsailtable.destroy();
			}
			microsailtable=$('#datatable-score-triangular-microsailboat').DataTable({
				paging: true
			});
		}       
	});
}
