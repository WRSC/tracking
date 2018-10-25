	function addDot(lat, lng, tracker_id){
		//alert(lat,lng)
		tracker_id = typeof tracker_id !== 'undefined' ? tracker_id : 12;
		var image = {
			url: 'icons/test0.png',
			size: new google.maps.Size(16, 19),
			origin: new google.maps.Point(0,0),
			anchor: new google.maps.Point(8, 19)
		};
		//alert(tracker_id)
		var marker = new google.maps.Marker(
			{
				position: new google.maps.LatLng(lat,lng),
				icon: image
			}
		);
		//always needed ?
		marker.setMap(replay_map);
		latest_markers[0].push(marker);
		latest_markers[1].push(tracker_id);
		//ADDED
		return marker;
	}

/*============================ Begin Add a Small Marker====================================*/  
  //Add a small marker to the map (a dot)
	//tracker_id is optional with  default value of 12 for the rendering
	
	function addSmallMarker(lat, lng, tracker_id, datetime){
		//alert(lat,lng)
		tracker_id = typeof tracker_id !== 'undefined' ? tracker_id : 12;
		var image = {
			url: 'icons/dot'+tracker_id%12+'.png',
			size: new google.maps.Size(5, 5),
			origin: new google.maps.Point(0,0),
			anchor: new google.maps.Point(3, 3)
		};
		//alert(tracker_id)
		var marker = new google.maps.Marker(
			{
				position: new google.maps.LatLng(lat,lng),
				icon: image
			}
		);
		//always needed ?
		marker.setMap(replay_map);
			
		latest_markers[0].push(marker);
		latest_markers[1].push(tracker_id);
		latest_markers[2].push(datetime);

		return marker;
	}
/*===============End Add a Small Marker=========================*/

/*==================Begin Add Big Marker==============================*/
	//Add a big marker to the map
	//tracker_id is optional with  default value of 12 for the rendering
	function addBigMarker(lat, lng, tracker_id,datetime){
		tracker_id = typeof tracker_id !== 'undefined' ? tracker_id : 12;
		var image = {
			url: 'icons/big'+tracker_id%12+'.png',
			size: new google.maps.Size(32, 37),
			origin: new google.maps.Point(0,0),
			anchor: new google.maps.Point(16, 37)
		};
		var marker = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			icon: image,
			
		}
		);
		//always needed ?
		marker.setMap(replay_map);
      
		latest_markers[0].push(marker);
		latest_markers[1].push(tracker_id);
		latest_markers[2].push(datetime);
		// to create the side panel
		//known_trackers.push(tracker_id);
		return marker;
	}
/*============================End Add Big Marker====================================*/

/*==============================Begin Add Draggable Marker===========================*/

//Add a draggable marker to the map
	function addDraggableMarker(lat, lng){
		var marker = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			draggable: true
		}
		);
		//always needed ?
		marker.setMap(replay_map);
		return marker;
	}
/*===================End Add Draggable Marker========================*/

	//Add all the given coordinates onto the map
	function addAllThisMarkers(data){
		var lat, lng, tracker_id = 0;
		for(var i=0; i < data.length ; i++){
			lat = data[i].latitude;
			lng = data[i].longitude;
			tracker_id = data[i].tracker_id;
			//addSmallMarker(lat,lng,tracker_id); //need to check
			
		}
	}

/*
	//Add the given coordiantes on the map and save this last state
	function refreshWithNewMarkers(data,map){
		var lastCoordinate = data[data.length-1];
		var lastDate = lastCoordinate.datetime;*/
		/*var lastLat = lastCoordinate.latitude;
		var lastLng= lastCoordinate.longitude;
		
		alert(lastDate)
		alert(lastLat)
		alert(lastLng)
		*/
		/*
		addAllThisMarkers(data,map);
		adaptZoom();
		//setCenter(lastLat,lastLng);
		if (lastDate!=null){
			saveLastDatetime(lastDate);
		}
	}*/

	//Add the given coordinates on the map and save this last state
	function refreshWithNewMarkers2(data){
		if (latest_markers[0].length>0){
			latest_markers[0][latest_markers[0].length-1].setMap(null);
		}
		addAllThesePolylines(data);
		adaptZoom();
	}

	function addAllThesePolylines(data){
		var tracker_Gcoords = []
		var last_coord = null
		if (latest_markers[0].length>0){
			last_latitude = latest_markers[0][latest_markers[0].length-1].getPosition().lat();
			last_longitude = latest_markers[0][latest_markers[0].length-1].getPosition().lng();
			last_coord = new google.maps.LatLng(last_latitude, last_longitude);
			last_datetime = latest_markers[2][latest_markers[0].length-1];
			last_track = latest_markers[1][latest_markers[0].length-1];
		}
		for(var i=0; i < data.length ; i++){ //iterate in the array
			latitude = data[i].latitude;
			longitude = data[i].longitude;
			tracker_id = data[i].tracker_id;
			// if (last_coord != null && last_track == tracker_id){
			// 	tracker_Gcoords.push(last_coord);
			// 	latest_markers[0][latest_markers[0].length-1].setMap(null);
			// 	addSmallMarker(last_latitude, last_longitude, last_track, last_datetime);	
			// 	last_coord = null;
			// }		
			datetime=data[i].datetime
			tracker_Gcoords.push(new google.maps.LatLng(latitude, longitude));
			
			if(i != data.length -1){ //not end of array
				if(data[i].tracker_id == data[i+1].tracker_id){ //the same tracker
					//addDot(latitude, longitude, tracker_id);	
					if (i%10==0){//every 10 coordinates add a small marker
						addSmallMarker(latitude, longitude, tracker_id, datetime);
					}	
				}
				else{ //derniere coordonnee du meme tracker si tracker different apres
					//create polyline
					//alert('changing tracker')
					createPolyline(tracker_Gcoords, tracker_id);
					//addbigmarker
					addBigMarker(latitude, longitude, tracker_id, datetime);
					
					//reset array
					tracker_Gcoords = [];
				}
			}
			else{ //end of array
				//create polyline
				createPolyline(tracker_Gcoords, tracker_id);
				//addsbigmarker
				addBigMarker(latitude, longitude, tracker_id, datetime);
				//reset array
				tracker_Gcoords = [];
			}
		}
	}

	function getLatestMarker(){
		return latest_markers[0][latest_markers[0].length-1]
	}

	function createPolyline(Gcoords, tracker_id){

		// colors:  		   red  , blue   , dark green, orange  , black    , purple   , white  , pink , fluo green, dark red, yellow , turquoise
		var colors = ['','#CC0000','#0000CC','#003300','#FF3300','#000000','#660099','#FFFFFF','#CC00CC','#00CC00','#660000','#FFFF00','#33FFFF']
		var index_of_marker = alreadyPresent(tracker_id);

		if(index_of_marker != -1){
			//get coords to add to polyline
			var end_lat = latest_markers[0][index_of_marker].getPosition().lat();
			var end_lng = latest_markers[0][index_of_marker].getPosition().lng();
			var end_tracker_id = latest_markers[1][index_of_marker];
			//Gcoords.unshift(new google.maps.LatLng(end_lat, end_lng));

			//remove this marker from the map
			//QUESTION better to replace the icon ??
			//deleteEndMarker(index_of_marker);
			//addSmallMarker(end_lat, end_lng, end_tracker_id);
		}

		var polyline = new google.maps.Polyline({
			path: Gcoords,
			geodesic: true,
			strokeColor: colors[tracker_id%12],
			strokeOpacity: 1.0,
			strokeWeight: 1
		});
		polyline.setMap(replay_map);

		displayed_polylines[0].push(polyline);
		displayed_polylines[1].push(tracker_id);
	}

// Remove all displayed markers and lines from the map
function clearMap(){
	for (var i = 0 ; i < latest_markers[0].length; i++) {
		latest_markers[0][i].setMap(null);
	}
	latest_markers = [[],[],[]];

	for (var i = 0 ; i < displayed_polylines[0].length; i++) {
		displayed_polylines[0][i].setMap(null);
	}
	displayed_polylines = [[], []];
}

	function deleteEndMarker(index_of_marker){
		latest_markers[0][index_of_marker].setMap(null);
		latest_markers[0][index_of_marker] = [];
	}

	function alreadyPresent(tracker_id){
		var index = -1;
		for (var i = 0 ; i < latest_markers[1].length; i++) {
			if (tracker_id == latest_markers[1][i] && latest_markers[0][i].getMap() != null){ //already existing on the map
				index = i;
			};
		};
		return index;
	}

	function refreshWithNextMarkers(data){

		addAllThesePolylines(data);

		adaptZoom();

	}
