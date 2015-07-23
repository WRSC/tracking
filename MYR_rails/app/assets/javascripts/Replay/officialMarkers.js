function drawOfficialMarkers(data){
	alert('enterd draw markers')
		alert(data.length)
	for (i=0;i<data.length;i++){
		alert(data[i].mtype)
		switch (data[i].mtype){
			case "Point":
				drawPoint(data[i])
				break
			case "Line":
				drawLine(data[i])
				break
			case "Polygon":
				drawPolygon(data[i])
				break
			case "Circle":
				drawCircle(data[i])
				break
		}
	}
}

function drawPoint(data){
	alert('enter draw point')
	tablat=data.latitude.split("_")
	tablng=data.longitude.split("_")
	for (i=0;i<tablat.length;i++){	
		fixPoint=addFixMarker(tablat[i],tablng[i])
	}

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
	for (i=0;i<tablat.length;i++){
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
