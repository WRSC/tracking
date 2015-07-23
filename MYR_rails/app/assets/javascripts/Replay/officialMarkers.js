function drawOfficialMarkers(data){
	alert('enterd draw markers')
	out=-1
	for (var i=0;i<data.length;i++){
		alert(i)
		alert(data[i].mtype)
		switch (data[i].mtype){
			case "Point":
				drawPoint(data[i]);
				out=i
				break;
			case "Line":
				drawLine(data[i]);
				break;
			case "Polygon":
				drawPolygon(data[i]);
			
				break;
			case "Circle":
				drawCircle(data[i]);
				break;
		}
	}
	alert('out is '+out)
}

function drawPoint(data){
	alert('enter draw point')
	tablat=data.latitude.split("_")
	tablng=data.longitude.split("_")
	alert('tablat length is '+tablat.length)
	for (var i=0;i<tablat.length;i++){	
		alert(i)
		if (tablat[i]!="" && tablng[i]!=""){
			alert(tablat[i])
			fixPoint=addFixMarker(tablat[i],tablng[i])
		}
	}
	return
}

function addFixMarker(lat, lng){
	//alert('lat is '+lat+' lng is '+lng)
	var marker = new google.maps.Marker(
	{
		position: new google.maps.LatLng(lat,lng),
		//icon: image
	});
	marker.setMap(replay_map);
	return marker;
}
	

function drawLine(data){
	alert('enter draw line')
	tablat=data.latitude.split("_")
	tablng=data.longitude.split("_")
}

function drawPolygon(data){
	alert('enter draw polygon')
	tablat=data.latitude.split("_")
	tablng=data.longitude.split("_")
	coord=[]
	for (var i=0;i<tablat.length;i++){
		coord.push(new google.maps.LatLng(tablat[i], tablng[i]))
	}
	polygon = new google.maps.Polygon({
    paths: coord,
    strokeColor: '#FF0000',
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: '#FF0000',
    fillOpacity: 0.35
  });
	polygon.setMap(replay_map)
	adaptZoom()
}

function drawCircle(data){
	alert('enter draw circle')
	tabcenter=data.latitude.split("_")
	tabradius=data.longitude.split("_")
}
