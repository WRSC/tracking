$(document).ready(function(){
	requestRenderSailboatTable(false,true)
	requestRenderMicroSailboatTable(false,true)
	$("#ranking-areascanning-sailboat").click(function(){
		//alert('clicked')
		requestRenderSailboatTable(true,false)
	})

	$("#ranking-areascanning-microsailboat").click(function(){
		requestRenderMicroSailboatTable(true,false)
	})
})

function requestRenderSailboatTable(flag,isFirst){
	$.ajax({
		type: "GET",
		url: "/areascanningsailboat",
		data: {flag: flag},
		success: function(){
			if (isFirst==false){
				sailtable.destroy();
			}
			sailtable=$('#datatable-score-areascanning-sailboat').DataTable({
				paging: true
			});
		}       
	});
}

function requestRenderMicroSailboatTable(flag,isFirst){
	$.ajax({
		type: "GET",
		url: "/areascanningmicrosailboat",
		data: {flag: flag},
		success: function(){
			if (isFirst==false){
				microsailtable.destroy();
			}
			microsailtable=$('#datatable-score-areascanning-microsailboat').DataTable({
				paging: true
			});
		}       
	});
}
