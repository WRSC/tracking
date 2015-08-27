//=require Markers/newmarker_map

//need to check adaptzoom

/*======variable global======*/
markers=[];
var mission_id=null;

$(document).ready(function(){
	
	initializeMap();
	initialScroll();
	loadMission()

});

function getMissionId(){
	return mission_id
}

function loadMission(){
	$("#marker_missions_dropdown").each(function(){
		var state = $('#marker_missions_dropdown :selected').val();
		if (state != "NULL"){
			mission_id = state;
			requestMissionMarkers(mission_id)
		}
	})

	$("#marker_missions_dropdown").change(function(){
		var state = $('#marker_missions_dropdown :selected').val();
		if (state != "NULL"){
			mission_id = state;
			requestMissionMarkers(mission_id)
		}
	})
}

function requestMissionMarkers(mission_id){
	$.ajax({
			type: "GET",
			url: "/missionMarkers",
			data: {mission_id: mission_id},
			dataType: "json",
			success: function(data){
				// if(data.length > 0){
					refreshWithNewMarkers(data,getMyMap());
				// }
			}       
		});
}

function refreshWithNewMarkers(data, map){
		$.ajax({
			type: "GET",
			url: "/mission_panel",
			data: {mission_id: mission_id},
			success: function(data){
			}       
		});
	for(var i=0; i < data.length; i++){
		switch (data[i].mtype){
			case "Point":
				drawPoint(data[i],map);
				break;
			case "Line":
				drawLine(data[i],map);
        		break;
			case "Polygon":
				drawPolygon(data[i],map);
				break;
			case "Circle":
				drawCircle(data[i],map);
				break;
		}
	}
}


function drawPoint(data,map){
	//alert('enter draw point')
	tablat=data.latitude.split("_")
	tablng=data.longitude.split("_")
	for (var i=0;i<tablat.length;i++){	
		if (tablat[i]!="" && tablng[i]!=""){
			fixPoint=addFixMarker(tablat[i],tablng[i],data.name,map)
		}
	}
}

function addFixMarker(lat, lng, name, map){
	//alert('lat is '+lat+' lng is '+lng)
	var image = {
					url: 'icons/bigBuoy2.png',
					size: new google.maps.Size(23, 37),
					origin: new google.maps.Point(0,0),
					anchor: new google.maps.Point(12, 37)
				};
	data = '<font color=\'black\'><div>'+'<b>Name: </b>'+name+'</div>'
	var temp = new google.maps.InfoWindow(
		{
			content: data
		}
	);

	var marker = new google.maps.Marker(
	{
		position: new google.maps.LatLng(lat,lng),
		icon: image
	});
	latest_buoys.push(marker)
	marker.setMap(map);
	addBuoyInfo(temp,marker,map)
	adaptZoom()
}
	
function addBuoyInfo(infowindow,buoy,map){
	google.maps.event.addListener(buoy, 'click', function(event) {
		var lat=event.latLng.lat()
		var lng=event.latLng.lng()
		myString='<div>'+'<b>Latitude: </b>'+lat+'&nbsp;'+'<b>Longitude: </b>'+lng+'</div>'+'</font>'
		infowindow.content+=myString
		infowindow.open(map,buoy);
	});
}

function drawLine(data, map){
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

  line.setMap(map)
}

function drawPolygon(data, map){
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
	polygon.setMap(map)
}

function drawCircle(data, map){
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
      map: map,
      center:  new google.maps.LatLng(lat,lng),
      radius: radius*1
    };
  circle = new google.maps.Circle(circleOptions);  
}
