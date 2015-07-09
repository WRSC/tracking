// Js handling the display of the buoys or markers, start line, end line, limits of an area for a mission

function displayMissionsBuoys(){
		$.ajax({
				type: "GET",
				data: {mission_id: getCurrentMission()},
				url: "/getMissionBuoys",
				success: function(data){
					if(data.length > 0){
						//refreshBuoys(data,getMap());
						//refreshWithNewMarkers2(data,getMap());
						refreshWithNewMarkers(data,getMap());
					}
				}       
		});
}