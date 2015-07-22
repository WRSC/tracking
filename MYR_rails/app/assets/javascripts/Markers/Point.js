/*
https://thenounproject.com/term/map-marker/51274/

color of icons RGB: 241 111 107
change color of marker
http://www.benramey.com/2012/03/15/change-the-color-of-an-icon-with-gimp/

https://developers.google.com/maps/documentation/javascript/examples/marker-remove

*/
BuoyMarkers=[]
	function saveBuoyMarker(){
		alert('saving')
		$.ajax({
						type: "POST",
						url: "/markers",
						data: {marker: BuoyMarkers},
						dataType: "json",
						success: function(data){
							alert('saved')
						}
		}) 	
	}

//---------------------  Buoy  -----------------------------------
	//Add a buoy on the map when clicked and keep track of coordinates on dragend
	//Save the coodinates in the database when clinking on "AddBuoy" button
	function addFixBuoy(){
		//alert('addFixBuoy')
		//need to check if the input data is right To do
		var lat = prompt("Please enter latitude", "0");
		var lng = prompt("Please enter longitude", "0");
		datetime=getCurrentTime()
		fixPoint=addFixMarker(lat,lng)
		//addDraggableMarker(lat, lng)
		setCenter(lat, lng)
		p={"latitude": lat, "longitude": lng, "mtype": "point", "datetime": datetime, "mission_id": 1}
		BuoyMarkers.push(p)
		// Add a listener for the click event.
		google.maps.event.addListener(fixPoint, 'click', showPoint);
		infoWindow = new google.maps.InfoWindow();
	}
	
	function addDraggableBuoy(){
		alert('You can click directly on the map in order to add draggable markers.')
		
		google.maps.event.addListener(map_marker, 'click', function(event) {
    	//alert('Lat: ' + event.latLng.lat() + ' Lng: ' + event.latLng.lng());
			lat=event.latLng.lat()
			lng=event.latLng.lng()
    	draggablePoint=addDraggableMarker(lat,lng);
			datetime=getCurrentTime()
			p={"latitude": lat, "longitude": lng, "mtype": "point", "datetime": datetime, "mission_id": 1}
			BuoyMarkers.push(p)

			// Add a listener for the click event.
			google.maps.event.addListener(draggablePoint, 'click', showPoint);
			infoWindow = new google.maps.InfoWindow();
  	});
			
	
	}
	
	//Add a draggable marker to the map
	function addDraggableMarker(lat,lng){
		//alert(lng)
		var marker = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			//icon: image,
			draggable: true
		});
		//always needed ?
		marker.setMap(map_marker);
		return marker;
	}
	
	
	function addFixMarker(lat, lng){

		var marker = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			//icon: image
		});
		marker.setMap(map_marker);
		return marker;
	}
	
	function setCenter(lat, lng){
		map_marker.panTo(new google.maps.LatLng(lat,lng));
	}


	function showPoint(event) {
		// Since this polygon has only one path, we can call getPath()
		// to return the MVCArray of LatLngs.
	

		var contentString = '<font color="black"><b>Coordinate of Buoy :</b><br>'
                        + '<b>latitude:</b>&nbsp'+event.latLng.lat() + ',&nbsp' + 
												'<b>longitude:</b>&nbsp'+event.latLng.lng() + '<br></font>';

  // Replace the info window's content and position.
  infoWindow.setContent(contentString);
  infoWindow.setPosition(event.latLng);

  infoWindow.open(map_marker);
	}

	function getCurrentTime(){
		currentTime=new Date()
		year=currentTime.getFullYear()
		month=currentTime.getMonth()+1
		if (month<10)
			month="0"+month
		else
			month=""+month

		return year+month+currentTime.getDate()+currentTime.getHours()+currentTime.getMinutes()+currentTime.getSeconds()
	}


	
