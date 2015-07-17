function addFixPolyline(){
	tabinput=prompt("Please respect the format of input data, otherwise it could not recognize the data: lat,lng;lat,lng;...","lat,lng; lat,lng...")
	/*====== need to check if th input data format is correct =====*/
	alert (tabinput)	
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
}

