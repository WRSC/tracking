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
        for (var j=0;j<LineMarkers.length;j++){
          var Linelat=""
          var Linelng=""
          var len=LineMarkers[j].getPath().getLength();
		      for (var i=0; i<len; i++) {
				    xy=LineMarkers[j].getPath().getAt(i)
				    lat=xy.lat()
				    lng=xy.lng()          	
				    Linelat+=lat+"_"
				    Linelng+=lng+"_"
		      }
          Linelat+=";"
          Linelng+=";"
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
	}


function addFixPolyline(){
	input=prompt("Please respect the format of input data, otherwise it could not recognize the data: lat,lng;lat,lng;...","lat,lng; lat,lng...")
	/*====== need to check if th input data format is correct =====*/
	tabinput=input.split(";")
	var coord=[]
  var fixline=[]
  var fixPath = new google.maps.Polyline({
    geodesic: true,
    strokeColor: '#FF0000',
    strokeOpacity: 1.0,
    strokeWeight: 2,
    markers: fixline
  });
  fixPath.setMap(map_marker)
  LineMarkers.push(fixPath)
  var path=fixPath.getPath()
  for (var i=0;i<tabinput.length;i++){
		latlng=tabinput[i].split(",")
		lat=latlng[0]
		lng=latlng[1]
		path.push(new google.maps.LatLng(lat, lng))
  	var node=addFixMarker(lat, lng)//in Point.js
		fixPath.markers.push(node)
    google.maps.event.addListener(node, 'click', showPointInLine);
		infoWindowLine = new google.maps.InfoWindow();
	}
}

function addCustomPolyline(){
  window.open('test')
  alert('You can add markers by clicking in the map directly')
	var polyOptions = {
    strokeColor: '#000000',
    strokeOpacity: 1.0,
    strokeWeight: 3,
    markers: []
  };
  poly = new google.maps.Polyline(polyOptions);
  poly.setMap(map_marker);
  // Add a listener for the click event
  google.maps.event.clearListeners(map_marker, 'click');
  google.maps.event.addListener(map_marker, 'click', addLatLng);
  LineMarkers.push(poly)
}

function addLatLng(event,a) {
// alert('enter in line event')
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
  poly.markers.push(marker)
  //LineMarkers.push(marker)
	google.maps.event.addListener(marker, 'click', showPointInLine);
	infoWindowLine = new google.maps.InfoWindow();
}


	function showPointInLine(event) {
		// Since this polygon has only one path, we can call getPath()
		// to return the MVCArray of LatLngs.
    pg=this
		var contentString = '<font color="black"><b>Coordinate of Buoy :</b><br>'+
                        '<b>latitude:</b>&nbsp'+event.latLng.lat() + ',&nbsp' + 
												'<b>longitude:</b>&nbsp'+event.latLng.lng() + '<br>'+'</font>'

			+'<input type="image" id="delete-pointInLine-buoy" src="/icons/delete_point_buoy.png" alt="delete me" height="20" width="20" title="delete me" style="float: right;" /></input><br>'
  // Replace the info window's content and position.
    infoWindowLine.setContent(contentString);
    infoWindowLine.setPosition(event.latLng);
    infoWindowLine.open(map_marker);
    $("#delete-pointInLine-buoy").click(function(){
      //var ind=findIndexInLine(pg)
      //alert('ind is '+ind)
      //alert('indcoord is '+indcoord)
      infoWindowLine.close()
      //poly.getPath().removeAt(indcoord)
      var nltab=findInwhichLine(pg)
      var indcoord=findIndexInCoordLine(event.latLng.lat(),event.latLng.lng(),nltab )
      LineMarkers[nltab[0]].getPath().removeAt(indcoord)
      LineMarkers[nltab[0]].markers[nltab[1]].setMap(null)
      LineMarkers[nltab[0]].markers[nltab[1]]=""
       //pg.markers[ind].setMap(null)
      //poly.markers[nltab[1]].setMap(null)
      //LineMarkers[ind]=""
    })
	  
  }
  function findInwhichLine(mark){
    idx=[]
    for (var i=0;i<LineMarkers.length;i++){
      for (var j=0;j<LineMarkers[i].markers.length;j++){
        if (mark==LineMarkers[i].markers[j]){
          idx.push(i)
          idx.push(j)
          return idx
        }
      }
    }
    return idx
  }

//find the index of point in the line(MVCarray)
  function findIndexInCoordLine(lat, lng, nltab ){
    var mvctab=LineMarkers[nltab[0]].getPath()
    for (var i=0;i<mvctab.length;i++){
      if (lat==mvctab.getAt(i).lat() && lng==mvctab.getAt(i).lng()){
        return i
      }
    }
    return -1
  }

//find the index of marker in the lineMarkers
  function findIndexInLine(pg){
    for (var i=0;i<LineMarkers.length;i++){
      if (LineMarkers[i]!="" ){
        for (var j=0;j<LineMarkers[i].markers.length;j++){
          if (pg==LineMarkers[i].markers[j])
            return j
        }
      }
    }
    return -1
  }


