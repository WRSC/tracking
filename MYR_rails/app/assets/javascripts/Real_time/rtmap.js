//----------------------GLOBAL VARIABLES-------------------

var lastDatetime = "10000101";
var latest_markers = [[],[]]; //[0] for markers and [1] for tracker id
var latest_buoys = [[],[]]; //[0] for buoys and [1] for mission id
var latest_buoys_line = [[],[]]; 
var lines = [[],[]]; // keep the lines in memories, [0] for lines and [1] for mission id
var known_trackers = [];
var desired_trackers = [];
var all_current_missions=[];
var current_mission;
var myReset;
var refreshRate = 10000;
var MAX_NUM_COORDS = 1000;
var index_first_marker = 0;
var index_next_new_marker = 0;
var first_launch = true;
var offset = 0;
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
	
	//get current missions
	function getAllCurrentMissions(missions){
		return all_current_missions;
	}
	
	function getIndexOfCurrentMission(){
		all=getAllCurrentMissions()
		targ=getCurrentMission()
		return all.index(targ)
	}
	
	//save current missions, need to clear all the missions before
	function setAllCurrentMissions(missions){
		all_current_missions=missions;
	}
	
	//get current mission (only one)
	function getCurrentMission(){
		return current_mission+''
	}
	
	//save a current mission (only a mission at a time in order to display)
	function saveCurrentMission(mission_id){
		current_mission=mission_id
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
	
	function getMyMap(){
		return map;
	}

	function getRefreshRate(){
		return refreshRate;
	}

	function setRefrestRate(newRefreshRate){
		refreshRate=newRefreshRate;
	}

	function getMaxCoords(){
		return MAX_NUM_COORDS;
	}

	function setMaxCoords(newMaxCoords){
		MAX_NUM_COORDS=newMaxCoords;
	}

	function getOffset(){
		return offset;
	}

	function setOffset(newOffset){
		offset=newOffset;
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
  controlImage.src = "icons/expand-icon-small.png";
  controlUI.appendChild(controlImage);

  // Setup the click event listeners: change the class of the map container
  google.maps.event.addDomListener(controlUI, 'click', function() {
  	$("#map-container").toggleClass("fullscreen");
  	google.maps.event.trigger(map, 'resize');
  });
}

/*========================= Begin initialize Google Map===============================================*/
	//Map initialization
	function initializeMap() {
		//reset the global variables
		latest_markers = [[],[]];
		latest_buoys = [[],[]];
		latest_buoys_line = [[],[]];
		desired_trackers = [];
		known_trackers = [];
		lines = [[],[]];;
		lastDatetime = "10000101";
      	if (myReset!= null){
      		clearInterval(myReset);
      	}
		refreshRate = $('#dropdown_select_refreshRate :selected').val();
		MAX_NUM_COORDS = $('#dropdown_select_maxCoords :selected').val();
		index_first_marker = 0;
		index_next_new_marker = 0;
		first_launch = true;
		//map options
		var mapOptions = {
			mapTypeId: google.maps.MapTypeId.HYBRID,
			center: new google.maps.LatLng(41.691806, -8.821782),
			zoom: 14,
			zoomControl: true,
			zoomControlOptions: {
				style: google.maps.ZoomControlStyle.SMALL,
				position: google.maps.ControlPosition.BOTTOM_LEFT
			},
			mapTypeControl: true,
			mapTypeControlOptions: {
				style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,
				position: google.maps.ControlPosition.TOP_CENTER
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

/*========================= Clear Google Map===============================================*/

function eraseMap() {
		//stop displaying the points
		for(var i=0; i < latest_markers[0].length ; i++){
			latest_markers[0][i].setMap(null);
		}
		for(var i=0; i < latest_buoys[0].length ; i++){
			latest_buoys[0][i].setMap(null);
		}
		for(var i=0; i < latest_buoys_line[0].length ; i++){
			latest_buoys_line[0][i].setMap(null);
		}
		for(var i=0; i < lines[0].length ; i++){
			lines[0][i].setMap(null);
		}
		//reset the global variables
		latest_markers = [[],[]];
		latest_buoys = [[],[]];
		latest_buoys_line = [[],[]];
		desired_trackers = [];
		known_trackers = [];
		lines = [[],[]];
		lastDatetime = "10000101";
      	if (myReset!= null){
      		clearInterval(myReset);
      	}
		refreshRate = $('#dropdown_select_refreshRate :selected').val();
		MAX_NUM_COORDS = $('#dropdown_select_maxCoords :selected').val();
		index_first_marker = 0;
		index_next_new_marker = 0;
		first_launch = true;
	}

function showTrackers(data){
	for(var i=0; i < data.length ; i++){
		tracker_id=data[i];
		disp = false;
		// boucle for allant du dernier marker ajouté (modulo(...)) jusqu'au plus ancien first_marker
		for(var j=moduloPositif(index_first_marker-1,latest_markers[0].length); j != index_first_marker; j=moduloPositif(j-1,MAX_NUM_COORDS)){
			if (!disp && tracker_id==latest_markers[1][j]){
				latest_markers[0][j].setMap(map);
				disp=true;
			}
		}
		if (!disp && tracker_id==latest_markers[1][index_first_marker]){
			latest_markers[0][j].setMap(map);
			disp=true;
		}
		for(var j=0;j<lines[0].length;j++){
			if (tracker_id==lines[1][j]){
				lines[0][j].setMap(map);
			}
		}
	}
}

function hideTrackers(data){
	for(var i=0; i < data.length ; i++){
		tracker_id=data[i];
		// boucle for allant du dernier marker ajouté (modulo(...)) jusqu'au plus ancien first_marker
		for(var j=0; j < latest_markers[0].length; j++){
			if ( tracker_id==latest_markers[1][j]){
				latest_markers[0][j].setMap(null);
			}
		}
		for(var j=0;j<lines[0].length;j++){
			if (tracker_id==lines[1][j]){
				lines[0][j].setMap(null);
			}
		}
	}
}

/*========================= End initialize Google Map===============================================*/

	//Set the center of the map
	function setCenter(lat, lng){
		map.panTo(new google.maps.LatLng(lat,lng));
	}

/*========================= End initialize Google Map===============================================*/

//Fit the zoom to see all the displayed points
	function adaptZoom(){
		if (latest_markers[0].length != 0){
			var bounds = new google.maps.LatLngBounds();
			// boucle for allant du marker le plus ancien (first_marker) dans le tableau jusqu'au plus récent moduloPositif(index_first_marker-1,latest_markers[0].length)
			for(var i=index_first_marker; i != moduloPositif(index_first_marker-1,latest_markers[0].length); i=(i+1)%MAX_NUM_COORDS){
				bounds.extend(latest_markers[0][i].getPosition());
			}
			bounds.extend(latest_markers[0][moduloPositif(index_first_marker-1,latest_markers[0].length)].getPosition());
			for(var i=0; i < latest_buoys[0].length ; i++){
				bounds.extend(latest_buoys[0][i].getPosition());
			}
		}
		else{
			var bounds = new google.maps.LatLngBounds();
			for(var i=0; i < latest_buoys[0].length ; i=i+1){
				bounds.extend(latest_buoys[0][i].getPosition());
			}
		}
		map.fitBounds(bounds);
	}
	
	function moduloPositif(a,b){
		if (a<0){
			return b+a
		}
		else{
			return a%b
		}
	}
//---------------------  BOILS  -----------------------------------
	//Add a boil on the map when clicked and keep track of coordinates on dragend
	//Save the coodinates in the database when clinking on "AddBoil" button
	function addingBoil(){
		google.maps.event.addListener(map, 'click', function(a){
			var desiredLat = a.latLng.lat();
			var desiredLng = a.latLng.lng();
			setCenter(desiredLat,desiredLng);

			var marker = addDraggableMarker(desiredLat,desiredLng);
			google.maps.event.addListener(marker, 'dragend', function(a){
				var markerLat = a.latLng.lat();
				var markerLng = a.latLng.lng();

				desiredLat = markerLat;
				desiredLng = markerLng;
			}
			);

			$("#AddBoil").click(function(){
				
				(desiredLat+" and "+desiredLng);

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
//------------------END SWARMON------------------------------
