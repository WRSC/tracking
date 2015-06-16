//----------------------GLOBAL VARIABLES-------------------
var map = null;
var lastDatetime = "0";
var latest_markers = [[],[]]; //[0] for markers and [1] for tracker id
var known_trackers = [];
var desired_trackers = [];

/*
var tab = [2,12,1,5];
tab.sort(function(a, b){return a-b});
alert(tab);
*/

//----------------------FUNCTIONS---------------------------

//-------------------GUI----------------------------------------
jQuery.expr.filters.offscreen = function(el) {
	return (
		(el.offsetLeft + el.offsetWidth) < 0 
		|| (el.offsetTop + el.offsetHeight) < 0
		|| (el.offsetLeft > window.innerWidth || el.offsetTop > window.innerHeight)
		);
};

	//scroll to top of button over the map
	function initialScroll(){
		$('html, body').animate({
			//carefull on the name of the HTML object here
			scrollTop: $("#above_the_map").offset().top
		}, 2000);
	}

//-------------GETTERS AND SETTERS----------------------------
	//Setter on lastDatetime
	function saveLastDatetime(datetime){
		lastDatetime = datetime;
	}

	//Getter on lastDatetime
	function getLastDatetime(){
		return lastDatetime;
	}

	//Setter on known_trackers
	function saveNewKnownTracker(new_tracker){
		var arrayLength = new_tracker.length;
		for (var i = 0; i < arrayLength; i++) {
			known_trackers.push(new_tracker[i]);
		}
	}

	//Getter on known_trackers
	function getKnownTrackers(){
		return known_trackers;
	}

	//Setter on desired_trackers
	function saveNewDesiredTracker(new_tracker){
			desired_trackers.push(new_tracker);
	}

	function removeDesiredTracker(this_tracker){
		//get index of the tracker
		var index = desired_trackers.indexOf(this_tracker);
  	if(index > -1){
	    //remove this element
	    desired_trackers.splice(index,1);
		}
	}

	//Getter on desired_trackers
	function getDesiredTrackers(){
		return desired_trackers;
	}

//--------MAP----------------
function FullScreenControl(controlDiv, map) {
	//see https://developers.google.com/maps/documentation/javascript/examples/control-custom

  // Set CSS for the control border
  var controlUI = document.createElement('div');
  controlUI.style.backgroundColor = '#fff';
  //controlUI.style.border = '2px solid #fff';
  controlUI.style.boxShadow = '0 2px 6px rgba(0,0,0,.3)';
  controlUI.style.cursor = 'pointer';
  controlUI.title = 'Click to hide the right panel';
  controlDiv.appendChild(controlUI);

  // Set image for the control interior
  var controlImage = document.createElement('img');
  controlImage.isMap = true;
  controlImage.src = "/icons/expand-icon-small.PNG";
  controlUI.appendChild(controlImage);

  // Setup the click event listeners: change the class of the map container
  google.maps.event.addDomListener(controlUI, 'click', function() {
  	$("#map-container").toggleClass("fullscreen");
  	google.maps.event.trigger(map, 'resize');
  });
}

	//Map initialization
	function initializeMap() {
		//map options
		var mapOptions = {
			mapTypeId: google.maps.MapTypeId.ROAD,
			center: new google.maps.LatLng(53.2590145, -9.0294632),
			zoom: 14,
			zoomControl: true,
			zoomControlOptions: {
				style: google.maps.ZoomControlStyle.SMALL,
				position: google.maps.ControlPosition.BOTTOM_LEFT
			},
			mapTypeControl: true,
			mapTypeControlOptions: {
				style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,
				position: google.maps.ControlPosition.BOTTOM_LEFT
			},
			scaleControl: true,
			streetViewControl: false,
			panControl: false,
			overviewMapControl: false
		}

		//map creation
		map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

		//add add button in the top right corner of the map to hide the right panel
		var centerControlDiv = document.createElement('div');
		var centerControl = new FullScreenControl(centerControlDiv, map);
		centerControlDiv.index = 1;
		map.controls[google.maps.ControlPosition.TOP_RIGHT].push(centerControlDiv);
	}



	//Set the center of the map
	function setCenter(lat, lng){
		map.panTo(new google.maps.LatLng(lat,lng));
	}


	//Add a small marker to the map (a dot)
	//tracker_id is optional with  default value of 12 for the rendering
	function addSmallMarker(lat, lng, tracker_id){
		tracker_id = typeof tracker_id !== 'undefined' ? tracker_id : 12;
		var image = {
			url: 'icons/dot'+tracker_id+'.png',
			size: new google.maps.Size(5, 5),
			origin: new google.maps.Point(0,0),
			anchor: new google.maps.Point(3, 3)
		};
		var marker = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			icon: image
		}
		);
		//always needed ?
		marker.setMap(map);
		//ADDED
		return marker;
	}
	/*
	//to complete
	//Add a marker to the map
	//tracker_id is optional with  default value of 12 for the rendering
	function addMarker(lat, lng, tracker_id){
		tracker_id = typeof tracker_id !== 'undefined' ? tracker_id : 12;
		var image = 'icons/medium'+tracker_id%12+'.png';

		var marker = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			icon: image
		}
		);
		//always needed ?
		marker.setMap(map);
		//ADDED
		return marker;
	}
	*/
	//Add a big marker to the map
	//tracker_id is optional with  default value of 12 for the rendering
	function addBigMarker(lat, lng, tracker_id){
		tracker_id = typeof tracker_id !== 'undefined' ? tracker_id : 12;
		var image = 'icons/medium'+tracker_id%12+'.png';

		var marker = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			icon: image
		}
		);
		//always needed ?
		marker.setMap(map);
		// to ease later addition of coordinqtes
		latest_markers[0].push(marker);
		latest_markers[1].push(tracker_id);
		// to create the side panel
		known_trackers.push(tracker_id);
		return marker;
	}

	//Add a draggable marker to the map
	function addDraggableMarker(lat, lng){
		var marker = new google.maps.Marker(
		{
			position: new google.maps.LatLng(lat,lng),
			draggable: true
		}
		);
		//always needed ?
		marker.setMap(map);
		return marker;
	}

	//Add all the given coordinates onto the map
	function addAllThisMarkers(data){
		var lat, lng, tracker_id = 0;
		for(var i=0; i < data.length ; i++){
			lat = data[i].latitude;
			lng = data[i].longitude;
			tracker_id = data[i].tracker_id;
			addMarker(lat,lng,tracker_id);
		}
	}

	//Add the given coordiantes on the map and save this last state
	function refreshWithNewMarkers(data){
		var lastCoordinate = data[data.length-1];
		var lastDate = lastCoordinate.datetime;
		var lastLat = lastCoordinate.latitude;
		var lastLng= lastCoordinate.longitude;

		addAllThisMarkers(data);
		setCenter(lastLat,lastLng);

		saveLastDatetime(lastDate);
	}

	//Add the given coordiantes on the map and save this last state
	function refreshWithNewMarkers2(data){
		var lastCoordinate = data[data.length-1];
		var lastDate = lastCoordinate.datetime;
		var lastLat = lastCoordinate.latitude;
		var lastLng= lastCoordinate.longitude;

		addAllThesePolylines(data);

		setCenter(lastLat,lastLng);
		saveLastDatetime(lastDate);
	}

	function addAllThesePolylines(data){
		var tracker_Gcoords = []
		for(var i=0; i < data.length ; i++){ //iterate in the array
			latitude = data[i].latitude;
			longitude = data[i].longitude;
			tracker_id = data[i].tracker_id;
			tracker_Gcoords.push(new google.maps.LatLng(latitude, longitude));
			if(i != data.length -1){ //not end of array
				if(data[i].tracker_id == data[i+1].tracker_id){ //the same tracker
					//addsmallmarker
					addSmallMarker(latitude, longitude, tracker_id);
				}
				else{
					//create polyline
					createPolyline(tracker_Gcoords, tracker_id);
					//addsbigmarker
					addBigMarker(latitude, longitude, tracker_id);
					//reset array
					tracker_Gcoords = [];
				}
			}
			else{ //end of array
				//create polyline
				createPolyline(tracker_Gcoords, tracker_id);
				//addsbigmarker
				addBigMarker(latitude, longitude, tracker_id);
				//reset array
				tracker_Gcoords = [];
			}
		}
	}

	function createPolyline(Gcoords, tracker_id, last_marker){

		// colors:  		   red  , blue   , dark green, orange  , black    , purple   , white  , pink , fluo green, dark red, yellow , turquoise
		var colors = ['','#CC0000','#0000CC','#003300','#FF3300','#000000','#660099','#FFFFFF','#CC00CC','#00CC00','#660000','#FFFF00','#33FFFF']
		var index_of_marker = alreadyPresent(tracker_id);

		if(index_of_marker != -1){
			//get coords to add to polyline
			var end_lat = latest_markers[0][index_of_marker].getPosition().lat();
			var end_lng = latest_markers[0][index_of_marker].getPosition().lng();
			var end_tracker_id = latest_markers[1][index_of_marker];
			Gcoords.unshift(new google.maps.LatLng(end_lat, end_lng));

			//remove this marker from the map
			//QUESTION better to replace the icon ??
			deleteEndMarker(index_of_marker);
			addSmallMarker(end_lat, end_lng, end_tracker_id);
		}

		var polyline = new google.maps.Polyline({
			path: Gcoords,
			geodesic: true,
			strokeColor: colors[tracker_id%12],
			strokeOpacity: 1.0,
			strokeWeight: 1
		});
		polyline.setMap(map);
	}

	function deleteEndMarker(index_of_marker){
		latest_markers[0][index_of_marker].setMap(null);
		latest_markers[0][index_of_marker] = [];
	}

	function alreadyPresent(tracker_id){
		var index = -1;
		for (var i = 0 ; i < latest_markers[1].length; i++) {
			if (tracker_id == latest_markers[1][i]){ //already existing on the map
				index = i;
			};
		};
		return index;
	}

//---------------------  BOILS  -----------------------------------
	//Add a boil on the map when clicked and keep track of coordinates on dragend
	//Save the coodinates in the database when clinking on "AddBoil" button
	function addingBoil(){
		google.maps.event.addListener(map, 'click', function(a){
			var desiredLat = a.latLng.lat();
			var desiredLng = a.latLng.lng();
			//setCenter(desiredLat,desiredLng);

			var marker = addDraggableMarker(desiredLat,desiredLng);
			google.maps.event.addListener(marker, 'dragend', function(a){
				var markerLat = a.latLng.lat();
				var markerLng = a.latLng.lng();

				desiredLat = markerLat;
				desiredLng = markerLng;
			}
			);

			$("#AddBoil").click(function(){
				alert(desiredLat+" and "+desiredLng);

				//to be completed using partial or jquery UI
				$.ajax({
					url: '/markers',
					type: 'POST',
					data: $.param({
						marker: {
							name: "test2",
							latitude: desiredLat,
							longitude: desiredLng
						}
					}),
					success: function(data) { alert("Marker has ben succesfully created"); }
				});
			});
		});
	}

//------------------------FROM SWARMON----------------------

//------------------------------CHOICE TEAMS---------------------------------------
//------------------------ ADD AND REMOVE TEAMS------------------------------------
function addteam(id){
	var str = $.cookie("teamslist");
	if(isPresent(id,str) == true){
  }//do nothing
  else{
    //si le cookie est inexistant ou vide
    if($.cookie("teamslist") == null || $.cookie("teamslist") == ""){
    	$.cookie("teamslist",id);
    }
      //sinon ajout
      else{
      	$.cookie("teamslist",$.cookie("teamslist")+","+id);
      }
    }
  }

  function rmvteam(id){
  	var str = $.cookie("teamslist");
  	var tab = str.split(",");
  //index de l'élément à retirer
  var index = tab.indexOf(id);
  if(index > -1){
    //retirer élément
    tab.splice(index,1);
    res = tab.toString();
    $.cookie("teamslist",res);
  }
}
//-------------------------------------------------------------------------------

//-------------------------------------------------------------------------------
function isPresent(id,str){
	if (str == null || str == ""){
    return false; //absent
  }
  else{
  	var tab = str.split(",");
  	var index = tab.indexOf(id);
  	if(index > -1){
  		return true;
  	}
  	else{
  		return false;
  	}
  }
}

//----------------------------ADD AND REMOVE ROBOTS--------------------------------
function addrobot(id){
	var str = $.cookie("robotslist");
	if(isPresent(id,str) == true){
  }//do nothing
  else{
    //si le cookie est inexistant ou vide
    if($.cookie("robotslist") == null || $.cookie("robotslist") == ""){
    	$.cookie("robotslist",id);
    }
      //sinon ajout
      else{
      	$.cookie("robotslist",$.cookie("robotslist")+","+id);
      }
    }
  }

  function rmvrobot(id){
  	var str = $.cookie("robotslist");
  	var tab = str.split(",");
  //index de l'élément à retirer
  var index = tab.indexOf(id);
  if(index > -1){
    //retirer élément
    tab.splice(index,1);
    res = tab.toString();
    $.cookie("robotslist",res);
  }
}
//-------------------------------------------------------------------------------

//-------------------------------------------------------------------------------
function isPresent(id,str){
	if (str == null || str == ""){
    return false; //absent
  }
  else{
  	var tab = str.split(",");
  	var index = tab.indexOf(id);
  	if(index > -1){
  		return true;
  	}
  	else{
  		return false;
  	}
  }
}
//-------------------------------------------------------------------------------

//------------------END SWARMON------------------------------
