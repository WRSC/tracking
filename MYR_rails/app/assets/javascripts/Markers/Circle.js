/*
more options to handle google map
https://developers.google.com/maps/documentation/javascript/geometry
*/

/*
for circle markers :
		latitude is the center
		longitude is the radius
*/
circleMarkers=[]
function saveCircleMarker(){
		if ($("#marker_missions_dropdown option:selected").val()==0){
			alert('Please choose a mission')
		}else{
			mission_id=$("#marker_missions_dropdown option:selected").val()
      var CircleCenter=""
      var CircleRadius=""
      for (var i=0;i<circleMarkers.length;i++){
  		  latlng=circleMarkers[i].getCenter() 
			  CircleCenter+=latlng.lat()+"_"+latlng.lng()
			  CircleRadius+=circleMarkers[i].getRadius()
      }
			p={"latitude": CircleCenter, "longitude": CircleRadius, "mtype": "Circle", "datetime": getCurrentTime(), "mission_id": mission_id}
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

function addFixCircle(){
	cen=prompt("Please input the center:","lat,long")
	radius=prompt("Please input the radius","radius")
	
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
  var circle = new google.maps.Circle(circleOptions);  
  google.maps.event.addListener(circle, 'click', showCircle);
  infoWindowCircle = new google.maps.InfoWindow();
  circleMarkers.push(circle)
}

function addCustomCircle(){
	cen=prompt("Please input the initial center:","lat,long")
	radius=prompt("Please input the initial radius","radius")
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
  var  circle = new google.maps.Circle(circleOptions);  
  google.maps.event.addListener(circle, 'click', showCircle);
  infoWindowCircle = new google.maps.InfoWindow();
  circleMarkers.push(circle)
}

  
function showCircle(event) {
  // Since this polygon has only one path, we can call getPath()
  // to return the MVCArray of LatLngs.
  pg=this //here this is the polygon
  var contentString = '<font color="black"><b>The coordinates of circle:</b><br>' +
      '<b>Clicked location: </b><br>' + event.latLng.lat() + ',&nbsp' + event.latLng.lng();

  cenlatlng=pg.getCenter()
  contentString +='<br>'+'<b>Center :</b><br>'+cenlatlng.lat()+',&nbsp'+cenlatlng.lng()
  contentString +='<br>'+'<b>Radius :</b><br>'+pg.getRadius()
	contentString +='<br /><input type="image" id="delete-circle-buoy" src="/icons/delete_point_buoy.png" alt="delete me" height="20" width="20" title="delete me" style="float: right;" /></input><br>'+'</font>'
  // Replace the info window's content and position.
  infoWindowCircle.setContent(contentString);
  infoWindowCircle.setPosition(event.latLng);
  infoWindowCircle.open(map_marker);
  $("#delete-circle-buoy").click(function(){
    var ind=findIndexInCircleMarkers(pg)
    alert(ind)
    infoWindowCircle.close()
    circleMarkers[ind].setMap(null)
    circleMarkers[ind]=""
  })
}

  function findIndexInCircleMarkers(pg){
    for (var i=0;i<circleMarkers.length;i++){
        if (circleMarkers[i]!="" && pg==circleMarkers[i]){
          return i
        }
    }
    return -1
  }

