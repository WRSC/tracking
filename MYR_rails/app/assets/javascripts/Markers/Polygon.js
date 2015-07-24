/*
more options to handle google map
https://developers.google.com/maps/documentation/javascript/geometry
*/
Polygonlat=""
Polygonlng=""
polygonMarkers=[]
function savePolygonMarker(){
		if ($("#marker_missions_dropdown option:selected").val()==0){
			alert('Please choose a mission')
		}else{
			mission_id=$("#marker_missions_dropdown option:selected").val()
			var len=customPolygon.getPath().getLength();
		  for (var i=0; i<len; i++) {
				xy=customPolygon.getPath().getAt(i)
				lat=xy.lat()
				lng=xy.lng()          	
				Polygonlat+=lat+"_"
				Polygonlng+=lng+"_"
		  }
			alert(Polygonlat)
			p={"latitude": Polygonlat, "longitude": Polygonlng, "mtype": "Polygon", "datetime": getCurrentTime(), "mission_id": mission_id}
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
  }
	  // Construct the polygon.
 	var fixPolygon = new google.maps.Polygon({
    paths: coord,
    strokeColor: '#FF0000',
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: '#FF0000',
    fillOpacity: 0.35
  });
	fixPolygon.setMap(map_marker)
  // Add a listener for the click event.
  google.maps.event.addListener(fixPolygon, 'click', showArrays);
  infoWindowPolgon = new google.maps.InfoWindow();
  polygonMarkers.push(fixpolygon)
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
  }
	  // Construct the polygon.
 	var customPolygon = new google.maps.Polygon({
    paths: coord,
    strokeColor: '#FF0000',
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: '#FF0000',
    fillOpacity: 0.35,
		editable:  true,
		draggable: true
  });
	customPolygon.setMap(map_marker)
	//add drag event
	google.maps.event.addListener(customPolygon, "dragend", updatePointsByDrag)
  // Add a listener for the click event.
  google.maps.event.addListener(customPolygon, 'click', showArrays);
  infoWindowPolygon = new google.maps.InfoWindow();
  polygonMarkers.push(customPolygon)
}


function updatePointsByDrag(){
    var len=customPolygon.getPath().getLength();
    for (var i=0; i<len; i++) {
			xy=customPolygon.getPath().getAt(i)
			lat=xy.lat()
			lng=xy.lng()          	
			Polygonlat=lat+"_"
			Polygonlng=lng+"_"
    }
		alert(Polygonlat)
};


/** @this {google.maps.Polygon} */
function showArrays(event) {
  // Since this polygon has only one path, we can call getPath()
  // to return the MVCArray of LatLngs.
  pg=this //here this is the polygon
  var vertices = this.getPath();

  var contentString = '<font color="black"><b>The coordinates of fix polygon :</b><br>' +
      '<b>Clicked location: </b><br>' + event.latLng.lat() + ',&nbsp' + event.latLng.lng();

  // Iterate over the vertices.
  for (var i =0; i < vertices.getLength(); i++) {
    var xy = vertices.getAt(i);
    contentString += '<br>' + '<b>Coordinate</b> ' + i + ':<br>' + xy.lat() + ',&nbsp' + xy.lng();
  }
	contentString +='<br /><input type="image" id="delete-polygon-buoy" src="/icons/delete_point_buoy.png" alt="delete me" height="20" width="20" title="delete me" style="float: right;" /></input><br>'
  +'</font>'
  // Replace the info window's content and position.
  infoWindowPolygon.setContent(contentString);
  infoWindowPolygon.setPosition(event.latLng);
  infoWindowPolygon.open(map_marker);
  $("#delete-polygon-buoy").click(function(){
    var ind=findIndexInPolygonMarkers(pg)
    alert(ind)
    infoWindowPolygon.close()
    polygonMarkers[ind].setMap(null)
    polygonMarkers[ind]=""
  })
}

  function findIndexInPolygonMarkers(pg){
    for (var i=0;i<polygonMarkers.length;i++){
        if (polygonMarkers[i]!="" && pg==polygonMarkers[i]){
          return i
        }
    }
    return -1
  }


