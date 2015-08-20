/*
https://thenounproject.com/term/map-marker/51274/

color of icons RGB: 241 111 107
change color of marker
http://www.benramey.com/2012/03/15/change-the-color-of-an-icon-with-gimp/

https://developers.google.com/maps/documentation/javascript/examples/marker-remove

*/
BuoyMarkers=[]//this table keep all the information about pont buoys
	function saveBuoyMarker(){
		if ($("#marker_missions_dropdown option:selected").val()==0){
			alert('Please choose a mission')
		}else{
      var Buoylat=""
      var Buoylng=""
			var Buoyname=""
			mission_id=$("#marker_missions_dropdown option:selected").val()
			for (var i=0;i<BuoyMarkers.length;i++){
        if (BuoyMarkers[i]!=""){
          Buoylat+=BuoyMarkers[i].position.lat()+";"
          Buoylng+=BuoyMarkers[i].position.lng()+";"
					Buoyname+=BuoyMarkers[i].mname+";"
        }
      }
      if (Buoylat=="" || Buoylng==""){
        alert('You do not creat any marker, please create some markers before you continue !!!')
      }else{
        p={"latitude": Buoylat, "longitude": Buoylng, "mtype": "Point", "datetime": getCurrentTime(), "mission_id": mission_id, "name": Buoyname}
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

//---------------------  Buoy  -----------------------------------
	//Add a buoy on the map when clicked and keep track of coordinates on dragend
	//Save the coodinates in the database when clinking on "AddBuoy" button
	function addFixBuoy(){
		//alert('addFixBuoy')
		//need to check if the input data is right To do
				var name = prompt("Please enter the name of marker","first buoy")
				var input = prompt("Please enter latitude and longitude", "0,0");
				var tabinput=input.split(",")
				var lat=tabinput[0]
				var lng=tabinput[1]
				//var lng = prompt("Please enter longitude", "0");
				fixPoint=addFixMarker(lat,lng,name)
				BuoyMarkers.push(fixPoint)
  		  //addDraggableMarker(lat, lng)
				// Add a listener for the click event.
				google.maps.event.addListener(fixPoint, 'click', showPoint);
				infoWindow = new google.maps.InfoWindow();
			
	
	}
	
	function addDraggableBuoy(){
				var name = prompt("Please enter the name of marker","first buoy")
				alert('You can click directly on the map in order to add draggable markers.')
		
				google.maps.event.addListener(map_marker, 'click', function(event) {
					//alert('Lat: ' + event.latLng.lat() + ' Lng: ' + event.latLng.lng());
			//    alert('enter in buoy event')
					lat=event.latLng.lat()
					lng=event.latLng.lng()
					draggablePoint=addDraggableMarker(lat,lng, name);
					BuoyMarkers.push(draggablePoint)

					// Add a listener for the click event.
					google.maps.event.addListener(draggablePoint, 'click', showPoint);
					infoWindow = new google.maps.InfoWindow();
					google.maps.event.clearListeners(map_marker, 'click');
				});
			
	}
	
	//Add a draggable marker to the map
	function addDraggableMarker(lat,lng, name){
		//alert(lng)
		var marker = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			mname: name,
			//icon: image,
			draggable: true
		});
		//always needed ?
		marker.setMap(map_marker);
		return marker;
	}
	
	
	function addFixMarker(lat, lng ,name){

		var marker = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			mname: name
			//icon: image
		});
		marker.setMap(map_marker);
		return marker;
	}
	
	function setCenter(lat, lng){
		map_marker.panTo(new google.maps.LatLng(lat,lng));
	}


	function showPoint(event) {
		// Since this polygon has only one path, we can call getPath()
		// to return the MVCArray of LatLngs.
	

		var contentString = '<font color="black"><b>Coordinate of Buoy :</b><br>'+
                        '<b>latitude:</b>&nbsp'+event.latLng.lat() + ',&nbsp' + 
												'<b>longitude:</b>&nbsp'+event.latLng.lng() + '<br>'+'</font>'

			+'<input type="image" id="delete-point-buoy" src="/icons/delete_point_buoy.png" alt="delete me" height="20" width="20" title="delete me" style="float: right;" /></input><br>'
  // Replace the info window's content and position.
    infoWindow.setContent(contentString);
    infoWindow.setPosition(event.latLng);
    infoWindow.open(map_marker);
    $("#delete-point-buoy").click(function(){
      var ind=findIndex(event.latLng.lat(),event.latLng.lng())
      infoWindow.close()
      BuoyMarkers[ind].setMap(null)
      BuoyMarkers[ind]=""

    })
	  
  }

  function findIndex(lat,lng){
    for (var i=0;i<BuoyMarkers.length;i++){
      
      if ( BuoyMarkers[i]!="" && lat==BuoyMarkers[i].position.lat() && lng==BuoyMarkers[i].position.lng() ){
 //       alert(i)
        return i
      }
    }
    return -1
  }

	function getCurrentTime(){
		currentTime=new Date()
		year=currentTime.getFullYear()
		month=currentTime.getMonth()+1
		month < 10 ? month= '0' + month : month=month+''
		day=currentTime.getDate()
		day < 10 ? day='0' + day : day=day+''
		hours=currentTime.getHours()
		hours < 10 ? hours='0' + hours: hours=hours+''
		mins=currentTime.getMinutes()
		mins < 10 ? mins='0' + mins: mins=mins+''
		secs=currentTime.getSeconds()
		secs < 10 ? secs='0'+ secs: secs=secs+''

		return year+month+day+hours+mins+secs
	}

	function renderpointinfo(){
		$.ajax({
			type: "get",
			url: "/pointinfo",
		
			success: function(data){
			
			}
		})
	}


	
