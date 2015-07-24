LineMarkers=[]
var poly=null
function saveLineMarker(){
		if ($("#marker_missions_dropdown option:selected").val()==0){
			alert('Please choose a mission')
		}else{
			mission_id=$("#marker_missions_dropdown option:selected").val()
			if (LineMarkers==[]){
        alert('You do not create any marker, please create some markers before you continue !!!')
      }else{
        var Linelat=""
        var Linelng=""
        var len=poly.getPath().getLength();
		    for (var i=0; i<len; i++) {
				  xy=poly.getPath().getAt(i)
				  lat=xy.lat()
				  lng=xy.lng()          	
				  Linelat+=lat+"_"
				  Linelng+=lng+"_"
		    }
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
	}


function addFixPolyline(){
	input=prompt("Please respect the format of input data, otherwise it could not recognize the data: lat,lng;lat,lng;...","lat,lng; lat,lng...")
	/*====== need to check if th input data format is correct =====*/
	tabinput=input.split(";")
	var coord=[]
  var fixline=[]
	for (i=0;i<tabinput.length;i++){
		latlng=tabinput[i].split(",")
		lat=latlng[0]
		lng=latlng[1]
		coord.push(new google.maps.LatLng(lat, lng))
  	var node=addFixMarker(lat, lng)//in Point.js
		google.maps.event.addListener(node, 'click', showPointInLine);
		infoWindowLine = new google.maps.InfoWindow();
  	fixline.push(node)
	}
  lineMarkers.push(fixline)
  var fixPath = new google.maps.Polyline({
    path: coord,
    geodesic: true,
    strokeColor: '#FF0000',
    strokeOpacity: 1.0,
    strokeWeight: 2,
    lineMarkers: fixline
  });
  fixPath.setMap(map_marker)
}

function addCustomPolyline(){
	alert('You can add markers by clicking in the map directly')
	var polyOptions = {
    strokeColor: '#000000',
    strokeOpacity: 1.0,
    strokeWeight: 3
  };
  poly = new google.maps.Polyline(polyOptions);
  poly.setMap(map_marker);
  // Add a listener for the click event
  google.maps.event.clearListeners(map_marker, 'click');
  google.maps.event.addListener(map_marker, 'click', addLatLng);
}

function addLatLng(event) {
    alert('enter in line event')
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
  LineMarkers.push(marker)
	google.maps.event.addListener(marker, 'click', showPointInLine);
	infoWindowLine = new google.maps.InfoWindow();
}


	function showPointInLine(event) {
		// Since this polygon has only one path, we can call getPath()
		// to return the MVCArray of LatLngs.
		var contentString = '<font color="black"><b>Coordinate of Buoy :</b><br>'+
                        '<b>latitude:</b>&nbsp'+event.latLng.lat() + ',&nbsp' + 
												'<b>longitude:</b>&nbsp'+event.latLng.lng() + '<br>'+'</font>'

			+'<input type="image" id="delete-pointInLine-buoy" src="/icons/delete_point_buoy.png" alt="delete me" height="20" width="20" title="delete me" style="float: right;" /></input><br>'
  // Replace the info window's content and position.
    infoWindowLine.setContent(contentString);
    infoWindowLine.setPosition(event.latLng);
    infoWindowLine.open(map_marker);
    $("#delete-pointInLine-buoy").click(function(){
      var ind=findIndexInLine(event.latLng.lat(),event.latLng.lng())
      var indcoord=findIndexInCoordLine(event.latLng.lat(),event.latLng.lng() )
      alert('ind is '+ind)
      alert('indcoord is '+indcoord)
      infoWindowLine.close()
      poly.getPath().removeAt(indcoord)
      LineMarkers[ind].setMap(null)
      LineMarkers[ind]=""

    })
	  
  }

  function findIndexInCoordLine(lat, lng ){
    var mvctab=poly.getPath()
    for (var i=0;i<mvctab.length;i++){
      if (lat==mvctab.getAt(i).lat() && lng==mvctab.getAt(i).lng()){
        return i
      }
    }
    return -1
  }

  function findIndexInLine(lat,lng){
    for (var i=0;i<LineMarkers.length;i++){
      
      if ( LineMarkers[i]!="" && lat==LineMarkers[i].position.lat() && lng==LineMarkers[i].position.lng() ){
 //       alert(i)
        return i
      }
    }
    return -1
  }


