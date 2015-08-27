function drawOfficialMarkers(data){
  //alert('enterd draw markers')
	for (var i=0;i<data.length;i++){
		switch (data[i].mtype){
			case "Point":
				drawPoint(data[i]);
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
}

function drawPoint(data){
	//alert('enter draw point')
	tablat=data.latitude.split("_")
	tablng=data.longitude.split("_")
	for (var i=0;i<tablat.length;i++){	
		if (tablat[i]!="" && tablng[i]!=""){
			fixPoint=addFixMarker(tablat[i],tablng[i],data)
		}
	}
}

function addFixMarker(lat, lng, marker){
	//alert('lat is '+lat+' lng is '+lng)
	var image = {
					url: 'icons/bigBuoy2.png',
					size: new google.maps.Size(23, 37),
					origin: new google.maps.Point(0,0),
					anchor: new google.maps.Point(12, 37)
				};
	data = '<font color=\'black\'><div>'+'<b>Name: </b>'+marker.name+'<br><b>Type: </b>'+marker.mtype+'<br><b>Description: </b>'+marker.description+'</div>'
	var temp = new google.maps.InfoWindow(
		{
			content: data
		}
	);

	var buoyMarker = new google.maps.Marker(
	{
		position: new google.maps.LatLng(lat,lng),
		icon: image
	});

	buoyMarker.setMap(replay_map);
	addBuoyInfo(temp,buoyMarker)
	return buoyMarker;
}
	
function addBuoyInfo(infowindow,buoy){
	google.maps.event.addListener(buoy, 'click', function(event) {
		var lat=event.latLng.lat()
		var lng=event.latLng.lng()
		myString='<div>'+'<b>Latitude: </b>'+lat+'&nbsp;'+'<b>Longitude: </b>'+lng+'</div>'+'</font>'
		infowindow.content+=myString
		infowindow.open(replay_map,buoy);
	});
}

function drawLine(data){
	//alert('enter draw line')
	tablat=data.latitude.split("_")
	tablng=data.longitude.split("_")
  	coord=[]
  	count=0
  	for (var i=0;i< tablat.length;i++){
    	if (tablat[i]!="" && tablng[i]!=""){
			count+=1
      	coord.push(new google.maps.LatLng(tablat[i], tablng[i]))
   		}
  	}
var lineSymbol = {
		    path: 'M 0,-1 0,1',
		    strokeOpacity: 1,
		    scale: 4
		};

var line = new google.maps.Polyline({
			path: coord,
			geodesic: true,
			icons: [{
      			icon: lineSymbol,
      			offset: '0',
      			repeat: '20px'
   			 }],
			strokeColor: '#FF0000',
			strokeOpacity: 0,
			strokeWeight: 2
		});

  line.setMap(replay_map)
}

function drawPolygon(data){
	//alert('enter draw polygon')
	tablat=data.latitude.split("_")
	tablng=data.longitude.split("_")
	coord=[]
	for (var i=0;i<tablat.length;i++){
    if (tablat[i]!="" && tablng[i]!=""){
      coord.push(new google.maps.LatLng(tablat[i], tablng[i]))
	  }
  }
	polygon = new google.maps.Polygon({
    paths: coord,
    strokeColor: '#FF0000',
	strokeOpacity: 0,
	strokeWeight: 2,
	fillColor: '#FF0000',
   	fillOpacity: 0.35

  });
	polygon.setMap(replay_map)
	adaptZoom()
}

function drawCircle(data){
    //alert('enter draw circle')
	tabcenter=data.latitude.split("_")
	tabradius=data.longitude.split("_")
	lat=tabcenter[0]
  lng=tabcenter[1]
  radius=tabradius[0]
  var circleOptions = {
      strokeColor: '#FF0000',
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: '#FF0000',
      fillOpacity: 0.35,
      map: replay_map,
      center:  new google.maps.LatLng(lat,lng),
      radius: radius*1
    };
  circle = new google.maps.Circle(circleOptions);  
}
