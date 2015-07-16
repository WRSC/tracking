//---------------------  BOILS  -----------------------------------
	//Add a boil on the map when clicked and keep track of coordinates on dragend
	//Save the coodinates in the database when clinking on "AddBoil" button
	function addBuoy(){
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
			}
			);

			$("#AddBoil").click(function(){
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
			});
		});
	}

