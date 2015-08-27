/*============================ Begin Add a Small Marker====================================*/  
  //Add a small marker to the map (a dot)
	//tracker_id is optional with  default value of 12 for the rendering
	function addSmallMarker(lat, lng, tracker_id, map){
		tracker_id = typeof tracker_id !== 'undefined' ? tracker_id : 12;
		var image = {
			url: 'icons/small'+tracker_id%12+'.png',
			size: new google.maps.Size(16, 19),
			origin: new google.maps.Point(0,0),
			anchor: new google.maps.Point(8, 19)
		};
		var marker = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			icon: image
		}
		);
		//always needed ?
		//marker.setMap(null);
		if (latest_markers[0].length < MAX_NUM_COORDS){
			latest_markers[0].push(marker);
			latest_markers[1].push(tracker_id);
			index_next_new_marker=(index_next_new_marker+1)%MAX_NUM_COORDS;
		}
		else{
			//latest_markers[0][latest_markers[0].length-1].setMap(null);
			if (latest_markers[0][index_next_new_marker].getMap()!=null){
				latest_markers[0][index_next_new_marker].setMap(null);
			}
			latest_markers[0][index_next_new_marker]=[];
			latest_markers[0][index_next_new_marker]=marker;
			latest_markers[1][index_next_new_marker]=tracker_id;
			index_first_marker = (index_first_marker+1)%MAX_NUM_COORDS;
			index_next_new_marker=(index_next_new_marker+1)%MAX_NUM_COORDS;
		}
		//ADDED
		return marker;
	}
/*=============================End Add a Small Marker========================================*/

/*	
	//to complete
	//Add a marker to the map
	//tracker_id is optional with  default value of 12 for the rendering
	function addMarker(lat, lng, tracker_id){
		tracker_id = typeof tracker_id !== 'undefined' ? tracker_id : 12;
		var image = {
			url: 'icons/medium'+tracker_id%12+'.png',
			size: new google.maps.Size(25, 29),
			origin: new google.maps.Point(0,0),
			anchor: new google.maps.Point(13, 29)
		};
		var marker = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			icon: image
		}
		);
		//always needed ?
		marker.setMap(map);
		//ADDED
		latest_markers[0].push(marker);
		latest_markers[1].push(tracker_id);
		return marker;
	}
*/	
	//Add a big marker to the map
	//tracker_id is optional with  default value of 12 for the rendering

/*==============================Begin Add Big Marker============================================*/
	function addBigMarker(lat, lng, tracker_id, map){
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
			icon: image
		}
		);
		//always needed ?
		marker.setMap(map);
		// to ease later addition of coordinqtes
		// to control the number of coordinates on the map
		if (latest_markers[0].length < MAX_NUM_COORDS){
			latest_markers[0].push(marker);
			latest_markers[1].push(tracker_id);
			index_next_new_marker=(index_next_new_marker+1)%MAX_NUM_COORDS;

		}
		else{
			//latest_markers[0][latest_markers[0].length-1].setMap(null);
			if (latest_markers[0][index_next_new_marker].getMap()!=null){
				latest_markers[0][index_next_new_marker].setMap(null);
			}
			latest_markers[0][index_next_new_marker]=[];
			latest_markers[0][index_next_new_marker]=marker;
			latest_markers[1][index_next_new_marker]=tracker_id;
			index_first_marker = (index_first_marker+1)%MAX_NUM_COORDS;
			index_next_new_marker=(index_next_new_marker+1)%MAX_NUM_COORDS;
		}
		// to create the side panel
		//known_trackers.push(tracker_id);
		return marker;
	}
/*================================End Add Big Marker=======================================*/


/*=================================Begin Add Draggable Marker==============================*/
/*
//Add a draggable marker to the map
	function addDraggableMarker(lat, lng,map){
		var marker = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			draggable: true
		}
		);
		//always needed ?
		marker.setMap(map);
		return marker;
	}*/
/*=================================End Add Draggable Marker================================*/

	//Add all the given coordinates onto the map
	function addAllThisMarkers(data,map){
		var lat, lng, tracker_id = 0;
		for(var i=0; i < data.length ; i++){
			lat = data[i].latitude;
			lng = data[i].longitude;
			tracker_id = data[i].tracker_id;
			addSmallMarker(lat,lng,tracker_id,map);
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
	function refreshWithNewMarkers2(data,map){//var latest_markers = [[],[]]; [0] for markers and [1] for tracker id
		/*if (latest_markers[0].length>0){
			latest_markers[0][latest_markers[0].length-1].setMap(null);
		}*/
		var lastCoordinate = data[data.length-1];
		var lastDate = getLastDatetime();
		for(var i=0; i < data.length ; i++){ //iterate in the array
			if (data[i].datetime > lastDate){
				lastDate = data[i].datetime;
			}
		}
		/*var lastLat = lastCoordinate.latitude;
		var lastLng= lastCoordinate.longitude;
		
		alert(lastDate)
		alert(lastLat)
		alert(lastLng)
		*/
		addAllThesePolylines(data,map);

		//setCenter(lastLat,lastLng);
		adaptZoom();
		if (lastDate!=10000101){
			saveLastDatetime(lastDate);
		}
	}

	function addAllThesePolylines(data,map){
		var tracker_Gcoords = []
		for(var i=0; i < data.length ; i++){ //iterate in the array
			latitude = data[i].latitude;
			longitude = data[i].longitude;
			tracker_id = data[i].tracker_id;		
			tracker_Gcoords.push(new google.maps.LatLng(latitude, longitude));
			if(i != (data.length-1)){ //not end of array
				if(data[i].tracker_id == data[i+1].tracker_id){ //the same tracker
					addSmallMarker(latitude, longitude, tracker_id,map);
				}
				else{ //derniere coordonnee du meme tracker si tracker different apres
					//create polyline
					createPolyline(tracker_Gcoords, tracker_id);
	
					//addsbigmarker
					addBigMarker(latitude, longitude, tracker_id,map);
					//reset array
					tracker_Gcoords = [];
				}
			}
			else{ //end of array
				//create polyline
				createPolyline(tracker_Gcoords, tracker_id);
				//addsbigmarker

				addBigMarker(latitude, longitude, tracker_id,map);
				//reset array

				tracker_Gcoords = [];
			}
		}
	}

	function createPolyline(Gcoords, tracker_id){

		// colors:  		   red  , blue   , dark green, orange  , black    , purple   , white  , pink , fluo green, dark red, yellow , turquoise
		var colors = ['','#CC0000','#0000CC','#003300','#FF3300','#000000','#660099','#FFFFFF','#CC00CC','#00CC00','#660000','#FFFF00','#33FFFF']
		var index_of_marker = alreadyPresent(tracker_id);
		//alert(index_of_marker)
		if(index_of_marker != -1){
			//get coords to add to polyline
			var end_lat = latest_markers[0][index_of_marker].getPosition().lat();
			var end_lng = latest_markers[0][index_of_marker].getPosition().lng();
			var end_tracker_id = latest_markers[1][index_of_marker];
			Gcoords.unshift(new google.maps.LatLng(end_lat, end_lng));

			//remove this marker from the map
			latest_markers[0][index_of_marker].setMap(null);
			//QUESTION better to replace the icon ??
			//deleteEndMarker(index_of_marker);
			//addSmallMarker(end_lat, end_lng, end_tracker_id);
		}

		var polyline = new google.maps.Polyline({
			path: Gcoords,
			geodesic: true,
			strokeColor: colors[tracker_id%13],
			strokeOpacity: 1.0,
			strokeWeight: 1
		});
		polyline.setMap(map);
		lines[0].push(polyline);
		lines[1].push(tracker_id);
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

