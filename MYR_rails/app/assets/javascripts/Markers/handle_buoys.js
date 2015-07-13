/*============================ Begin Add a Small Buoy================================================*/  
  //Add a small Buoy to the map (a dot)
	//mission_id is optional with  default value of 12 for the rendering
	function addSmallBuoy(lat, lng, mission_id, map){
		mission_id = typeof mission_id !== 'undefined' ? mission_id : 12;
		var image = {
			url: 'icons/small'+mission_id%12+'.png',
			size: new google.maps.Size(16, 19),
			origin: new google.maps.Point(0,0),
			anchor: new google.maps.Point(8, 19)
		};
		var buoy = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			icon: image
		}
		);
		//always needed ?
		buoy.setMap(map);
		//ADDED
		latest_buoys[0].push(buoy);
		latest_buoys[1].push(mission_id);
		return buoy;
	}
/*=============================Begin Add a Medium Buoy========================================*/
	
	//to complete
	//Add a Buoy to the map
	//mission_id is optional with  default value of 12 for the rendering
	function addBuoy(lat, lng, mission_id){
		mission_id = typeof mission_id !== 'undefined' ? mission_id : 12;
		var image = {
			url: 'icons/medium'+mission_id%12+'.png',
			size: new google.maps.Size(25, 29),
			origin: new google.maps.Point(0,0),
			anchor: new google.maps.Point(13, 29)
		};
		var buoy = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			icon: image
		}
		);
		//always needed ?
		buoy.setMap(map);
		//ADDED
		latest_buoys[0].push(buoy);
		latest_buoys[1].push(mission_id);
		return buoy;
	}
	
	//Add a big Buoy to the map
	//mission_id is optional with  default value of 12 for the rendering

/*==============================Begin Add Big Buoy============================================*/
	function addBigBuoy(lat, lng, mission_id, map){
		mission_id = typeof mission_id !== 'undefined' ? mission_id : 12;
		var image = {
			url: 'icons/big'+mission_id%12+'.png',
			size: new google.maps.Size(32, 37),
			origin: new google.maps.Point(0,0),
			anchor: new google.maps.Point(16, 37)
		};
		var buoy = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			icon: image
		}
		);
		//always needed ?
		buoy.setMap(map);
		// to ease later addition of coordinqtes
		latest_buoys[0].push(buoy);
		latest_buoys[1].push(mission_id);
		return buoy;
	}
/*================================End Add Big buoy=======================================*/

/*=================================Begin Add Draggable buoy==============================*/
	//Add a draggable buoy to the map
	function addDraggableBuoy(lat, lng,map){
		var buoy = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			draggable: true
		}
		);
		//always needed ?
		buoy.setMap(map);
		return buoy;
	}
/*=================================End Add Draggable buoy================================*/

	//Add all the given coordinates onto the map
	function addAllThisBuoys(data,map){
		var lat, lng, mission_id = 0;
		for(var i=0; i < data.length ; i++){
			lat = data[i].latitude;
			lng = data[i].longitude;
			mission_id = data[i].mission_id;
			addSmallBuoy(lat,lng,mission_id,map);
		}
	}


/*=================================load small buoy================================*/

function loadBuoy(lat, lng, mission_id){
		mission_id = typeof mission_id !== 'undefined' ? mission_id : 12;
		var image = {
			url: 'icons/bigBuoy1.png',
			size: new google.maps.Size(30, 47),
			origin: new google.maps.Point(0,0),
			anchor: new google.maps.Point(15, 47)
		};
		var buoy = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			icon: image
		}
		);
		latest_buoys[0].push(buoy);
		latest_buoys[1].push(mission_id);
		return buoy;
}

		//Add all the given coordinates onto the map
	function loadAllThisBuoys(data,map){
		var lat, lng, mission_id = 0;
		for(var i=0; i < data.length ; i++){
			lat = data[i].latitude;
			lng = data[i].longitude;
			mission_id = data[i].mission_id;
			loadBuoy(lat,lng,mission_id,map);
		}
	}

	function loadWithNewBuoys(data,map){
		var lastCoordinate = data[data.length-1];
		var lastLat = lastCoordinate.latitude;
		var lastLng= lastCoordinate.longitude;
		/*
		alert(lastDate)
		alert(lastLat)
		alert(lastLng)
		*/
		loadAllThisBuoys(data,map);
	}


	//Add the given coordiantes on the map and save this last state
	function refreshWithNewBuoys(data,map){
		/*var lastCoordinate = data[data.length-1];
		var lastLat = lastCoordinate.latitude;
		var lastLng= lastCoordinate.longitude;
		
		alert(lastDate)
		alert(lastLat)
		alert(lastLng)
		
		addAllThisBuoys(data,map);
		setCenter(lastLat,lastLng);*/
		var mission_id = 0;
		for(var i=0; i < data.length ; i++){
			mission_id = data[i].mission_id;
			var index_of_buoy = notDisplayed(mission_id);
			//alert(latest_buoys[1][i])
			if(index_of_buoy != -1){
				displayBuoy(index_of_buoy,map);
			}
		}
	}

	function refreshWithoutBuoys(data){
		var mission_id = 0;
		for(var i=0; i < data.length ; i++){
			mission_id = data[i].mission_id;
			var index_of_buoy = buoyAlreadyPresent(mission_id);
			//alert(index_of_buoy)
			if(index_of_buoy != -1){
				hideEndbuoy(index_of_buoy);
			}
		}
	}

	function hideEndbuoy(index_of_buoy){
		latest_buoys[0][index_of_buoy].setMap(null);
		//latest_buoys[0][index_of_buoy] = []; => just hiding
	}

	function displayBuoy(index_of_buoy, map){
		latest_buoys[0][index_of_buoy].setMap(map);
	}

	function buoyAlreadyPresent(mission_id){
		var index = -1;
		for (var i = 0 ; i < latest_buoys[1].length; i++) {
			if (mission_id == latest_buoys[1][i] && latest_buoys[0][i].getMap() != null){ //already existing on the map
				index = i;
			};
		};
		return index;
	}

	function notDisplayed(mission_id){
		var index = -1;
		for (var i = 0 ; i < latest_buoys[1].length; i++) {
			if (mission_id == latest_buoys[1][i] && latest_buoys[0][i].getMap() == null){ //not on the map
				index = i;
			};
		};
		return index;
	}
