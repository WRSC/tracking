/*
https://thenounproject.com/term/map-marker/51274/

change color of marker
http://www.benramey.com/2012/03/15/change-the-color-of-an-icon-with-gimp/

*/

//---------------------  Buoy  -----------------------------------
	//Add a buoy on the map when clicked and keep track of coordinates on dragend
	//Save the coodinates in the database when clinking on "AddBuoy" button
	function addBuoy(lat,lng){
		alert('addBuoy')
		var lat = prompt("Please enter latitude", "Harry Potter");
		addFixMarker(lat,lng)
		//addDraggableMarker(lat, lng)
		setCenter(lat, lng)
		

		/*
		google.maps.event.addListener(map, 'click', function(a){
			var desiredLat = a.latLng.lat();
			var desiredLng = a.latLng.lng();
			setCenter(desiredLat,desiredLng);

			var marker = addDraggableMarker(desiredLat,desiredLng);
			google.maps.event.addListener(marker, 'dragend', function(a){
				var markerLat = a.latLng.lat();
				var markerLng = a.latLng.lng();

				desiredLat = markerLat;
				desiredLng = markerLng;
			});

			alert(desiredLat+" and "+desiredLng);

			//to be completed using partial or jquery UI
			$.ajax({
				url: '/markers',
				type: 'POST',
				data: $.param({
					marker: {
						name: "test2",
						latitude: desiredLat,
						longitude: desiredLng
					}
				}),
				success: function(data) { alert("Marker has ben succesfully created"); }
			});
		});*/

	}
	
	//Add a draggable marker to the map
	function addDraggableMarker(lat, lng){
		var marker = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			//icon: image,
			draggable: true
		}
		);
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
	
