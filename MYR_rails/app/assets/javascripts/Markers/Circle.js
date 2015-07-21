/*
more options to handle google map
https://developers.google.com/maps/documentation/javascript/geometry
*/
function addFixCircle(){
	cen=prompt("Please input the center:","")
	radius=prompt("Please input the radius","")
	
	/*====== need to check if th input data format is correct =====*/
	latlng=cen.split(",")	
	lat=latlng[0]
	lng=latlng[1]

	var circleOptions = {
      strokeColor: '#FF0000',
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: '#FF0000',
      fillOpacity: 0.35,
      map: map_marker,
      center:  new google.maps.LatLng(lat,lng),
      radius: radius*1
    };
    // Add the circle for this city to the map.
    circle = new google.maps.Circle(circleOptions);  
		setCenter(lat,lng)
}

function addCustomCircle(){
	cen=prompt("Please input the center:","")
	radius=prompt("Please input the radius","")
	
	/*====== need to check if th input data format is correct =====*/
	latlng=cen.split(",")	
	lat=latlng[0]
	lng=latlng[1]

	var circleOptions = {
      strokeColor: '#FF0000',
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: '#FF0000',
      fillOpacity: 0.35,
      map: map_marker,
      center:  new google.maps.LatLng(lat,lng),
      radius: radius*1,
			editable:  true,
			draggable: true
    };
    // Add the circle for this city to the map.
    circle = new google.maps.Circle(circleOptions);  
		setCenter(lat,lng)
}



