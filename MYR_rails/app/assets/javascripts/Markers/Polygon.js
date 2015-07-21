/*
more options to handle google map
https://developers.google.com/maps/documentation/javascript/geometry
*/
function addFixPolygon(){
	//alert('add fix polygon')
	input=prompt("Please respect the format of input data, otherwise it could not recognize the data: lat,lng;lat,lng;...","lat,lng; lat,lng...")
	/*====== need to check if th input data format is correct =====*/
	coord=[]
  tabinput=input.split(";")
	for (i=0;i<tabinput.length;i++){
		latlng=tabinput[i].split(",")
		lat=latlng[0]
		lng=latlng[1]
		coord.push(new google.maps.LatLng(lat, lng))
		markers.push(addFixMarker(lat, lng))//in Point.js
  }
	  // Construct the polygon.
 	fixPolygon = new google.maps.Polygon({
    paths: coord,
    strokeColor: '#FF0000',
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: '#FF0000',
    fillOpacity: 0.35
  });
	fixPolygon.setMap(map_marker)
	adaptZoom()
  // Add a listener for the click event.
  google.maps.event.addListener(fixPolygon, 'click', showArrays);

  infoWindow = new google.maps.InfoWindow();
}

function addCustomPolygon(){
		//alert('add fix polygon')
	input=prompt("Please input the initial coordinates of your polygon (The polygon is editable and draggable) and respect the format of input data, otherwise it could not recognize the data: lat,lng;lat,lng;...","")
	/*====== need to check if th input data format is correct =====*/
	coord=[]
  tabinput=input.split(";")
	for (i=0;i<tabinput.length;i++){
		latlng=tabinput[i].split(",")
		lat=latlng[0]
		lng=latlng[1]
		coord.push(new google.maps.LatLng(lat, lng))
		//markers.push(addFixMarker(lat, lng))//in Point.js
  }
	  // Construct the polygon.
 	fixPolygon = new google.maps.Polygon({
    paths: coord,
    strokeColor: '#FF0000',
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: '#FF0000',
    fillOpacity: 0.35,
		editable:  true,
		draggable: true
  });
	fixPolygon.setMap(map_marker)
	adaptZoom()
  // Add a listener for the click event.
  google.maps.event.addListener(fixPolygon, 'click', showArrays);

  infoWindow = new google.maps.InfoWindow();
}

/** @this {google.maps.Polygon} */
function showArrays(event) {
  // Since this polygon has only one path, we can call getPath()
  // to return the MVCArray of LatLngs.
  var vertices = this.getPath();

  var contentString = '<font color="black"><b>The coordinates of fix polygon :</b><br>' +
      'Clicked location: <br>' + event.latLng.lat() + ',&nbsp' + event.latLng.lng() +
      '<br>';

  // Iterate over the vertices.
  for (var i =0; i < vertices.getLength(); i++) {
    var xy = vertices.getAt(i);
    contentString += '<br>' + 'Coordinate ' + i + ':<br>' + xy.lat() + ',' +
        xy.lng();
  }
	contentString +='</font>'
  // Replace the info window's content and position.
  infoWindow.setContent(contentString);
  infoWindow.setPosition(event.latLng);

  infoWindow.open(map_marker);
}


