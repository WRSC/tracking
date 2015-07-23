Linelat=""
Linelng=""

function saveLineMarker(){
		if ($("#marker_missions_dropdown option:selected").val()==0){
			alert('Please choose a mission')
		}else{
			mission_id=$("#marker_missions_dropdown option:selected").val()
			var len=poly.getPath().getLength();
		  for (var i=0; i<len; i++) {
				xy=poly.getPath().getAt(i)
				lat=xy.lat()
				lng=xy.lng()          	
				Linelat+=lat+"_"
				Linelng+=lng+"_"
		  }
			alert(Linelat)
			p={"latitude": Linelat, "longitude": Linelng, "mtype": "Line", "datetime": getCurrentTime(), "mission_id": mission_id}
			$.ajax({
							type: "POST",
							url: "/markers",
							data: {	marker: p},
							dataType: "json",
							success: function(data){
								alert('saved')
							}
			}) 	
		}
	}


function addFixPolyline(){
	input=prompt("Please respect the format of input data, otherwise it could not recognize the data: lat,lng;lat,lng;...","lat,lng; lat,lng...")
	/*====== need to check if th input data format is correct =====*/
	tabinput=input.split(";")
	var coord=[]
	for (i=0;i<tabinput.length;i++){
		latlng=tabinput[i].split(",")
		lat=latlng[0]
		lng=latlng[1]
		Linelat+=lat+"_"
		Linelng+=lng+"_"
		coord.push(new google.maps.LatLng(lat, lng))
		markers.push(addFixMarker(lat, lng))//in Point.js
	}
  var fixPath = new google.maps.Polyline({
    path: coord,
    geodesic: true,
    strokeColor: '#FF0000',
    strokeOpacity: 1.0,
    strokeWeight: 2
  });
  fixPath.setMap(map_marker)
	adaptZoom()
}

function addCustomPolyline(){
	alert('entered')
	var polyOptions = {
    strokeColor: '#000000',
    strokeOpacity: 1.0,
    strokeWeight: 3
  };
  poly = new google.maps.Polyline(polyOptions);
  poly.setMap(map_marker);

  // Add a listener for the click event
  google.maps.event.addListener(map_marker, 'click', addLatLng);
  
}

function addLatLng(event) {

  var path = poly.getPath();

  // Because path is an MVCArray, we can simply append a new coordinate
  // and it will automatically appear.
  path.push(event.latLng);


  // Add a new marker at the new plotted point on the polyline.
  var marker = new google.maps.Marker({
    position: event.latLng,
    title: '#' + path.getLength(),
    map: map_marker
  });
  markers.push(marker)
}

function adaptZoom(){
		var bounds = new google.maps.LatLngBounds();
		for(var i=0; i < markers[0].length ; i++){
			bounds.extend(markers[0][i].getPosition());
		}
		map_marker.fitBounds(bounds);
}

