// Js handling the display of the buoys or markers, start line, end line, limits of an area for a mission

function dispBuoys_checkbox_cookie(){
	$("input[id='dispBuoys']").each(function(){
		  var id = $(this).attr('id');
		  var str = $.cookie("dispbuoys");
		  //index de l'élément à retirer
		  if(str > 0){
		    $(this).prop('checked',true);
		  }
		  else{
		    $(this).prop('checked',false);
		  }
  	});
}

function loadMissionBuoys(){
	$.ajax({
				type: "GET",
				data: {mission_id: getCurrentMission()},
				url: "/getMissionBuoys",
				success: function(data){
					if(data.length > 0){
						loadWithNewBuoys(data,getMap());
					}
				}       
		});
}

function displayMissionsBuoys(){	
	$("input[id='dispBuoys']").each(function(){
		if($(this).is(':checked')){
        	getBuoys()
       	}
	});

	$("#dispBuoys").click(function(){
      if($(this).is(':checked')){
        getBuoys()
        $.cookie("dispbuoys",1);
      }else{//si décoché
      	hideBuoys()
		$.cookie("dispbuoys",0);
      }
	});

}

function getBuoys(){
		$.ajax({
				type: "GET",
				data: {mission_id: getCurrentMission()},
				url: "/getMissionBuoys",
				success: function(data){
					if(data.length > 0){
						//refreshBuoys(data,getMap());
						//refreshWithNewMarkers2(data,getMap());
						refreshWithNewBuoys(data,getMap());
					}
				}       
		});
}

function hideBuoys(){
		$.ajax({
				type: "GET",
				data: {mission_id: getCurrentMission()},
				url: "/getMissionBuoys",
				success: function(data){
					if(data.length > 0){
						//refreshBuoys(data,getMap());
						//refreshWithNewMarkers2(data,getMap());
						refreshWithoutBuoys(data,getMap());
					}
				}       
		});
}