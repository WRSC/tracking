
//----------------------GLOBAL VARIABLES-------------------
var replay_map=null
var lastDatetime = "10000101";
var latest_markers = [[],[],[]]; //[0] for markers and [1] for tracker id
var known_trackers = [];
var desired_trackers = [];
var showInfo = false;
var doReplay = false;
var singleAttempt = true;
var myReset = null;
var firstLaunch = false;

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
	
	function getReplayMap(){
		return replay_map;
	}
	
	function setReplayMap(desired_map){
		replay_map=desired_map
	}

	function getShowInfo(){
		return showInfo
	}

	function setShowInfo(val){
		showInfo=val
	}

	function getDoReplay(){
		return doReplay
	}

	function setDoReplay(val){
		doReplay=val
	}

	function getSingleAttempt(){
		return singleAttempt
	}

	function setSingleAttempt(val){
		singleAttempt=val
	}

	function getFirstLaunch(){
		return firstLaunch
	}

	function setFirstLaunch(val){
		firstLaunch=val
	}

//--------MAP----------------
function FullScreenControl(controlDiv) {
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
  	//https://developers.google.com/maps/documentation/javascript/reference#Map
  	google.maps.event.trigger(replay_map, 'resize');
  });
}

	//Map initialization
	function initializeMap() {
		lastDatetime = "10000101";
		latest_markers = [[],[],[]]; //[0] for markers and [1] for tracker id
		known_trackers = [];
		desired_trackers = [];
		//map options
		var mapOptions = {
			mapTypeId: google.maps.MapTypeId.ROAD,
			center: new google.maps.LatLng(60.103462, 19.928225),
			zoom: 14,
			zoomControl: true,
			zoomControlOptions: {
				style: google.maps.ZoomControlStyle.SMALL,
				position: google.maps.ControlPosition.RIGHT_BOTTOM
			},
			mapTypeControl: true,
			mapTypeControlOptions: {
				style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,
				position: google.maps.ControlPosition.TOP_CENTER
			},
		
			scaleControl: true,
			streetViewControl: false,
			panControl: true,
			overviewMapControl: true
		}

		//map creation
		replay_map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
		
		var contentString = '<p><font color=\'black\'>Aland university</font></p>'
 

		var infowindow = new google.maps.InfoWindow({
				content: contentString
		});
/*
		var marker = new google.maps.Marker({
				position:  new google.maps.LatLng(60.103462, 19.928225),
				map: replay_map,
				title: 'Aland University'
		});
*/		
		initialmarker=addDraggableMarker(60.103462, 19.928225,  replay_map)
		// addInfoWindow(infowindow,initialmarker)
		
		
		//add add button in the top right corner of the map to hide the right panel
		var centerControlDiv = document.createElement('div');
		var centerControl = new FullScreenControl(centerControlDiv);
		centerControlDiv.index = 1;
		replay_map.controls[google.maps.ControlPosition.TOP_RIGHT].push(centerControlDiv);
		replay_map.setTilt(45);
		
		//when we reload map, clear all the data in global variable	
		latest_markers = [[],[],[]]; //[0] for markers and [1] for tracker id
		
	}
	
	function displayInfoWindow(){
		var markerTemp = [];
		var tracker_idTemp = 0;
		var datetimeTemp = 0.0;
		var latTemp = 0.0;
		var lngTemp = 0.0;
		var changeInfowindow=[];
		var count = 0;
		var string = '';
		$.ajax({
				type: "GET",
				url: "/infoAttempt",
				data: {singleAttempt: getSingleAttempt()},
				dataType: "json",
				success: function(data){
					var attempt = data[0];
					var robot = data[1];
					var mission = data[2];
					var team = data[3];
					for(var i=0; i < latest_markers[0].length ; i++){
						if (i!= latest_markers[0].length-1){
							string = '<font color=\'black\'>'+'<div id=\'infowindow-title\'><p><b><center><u>Data Info:</u>'+'</center></b><p></div>'+'<div id=\'infowindow\'>'+'<p><b>Team:</b>'+ team.name+ '&nbsp <b>Robot:</b>'+robot.name +'</p>'+'<p><b>Mission:</b>'+mission.name+' &nbsp; <b>Attempt</b>'+ attempt.name + '</p><p><b>Datetime:</b>'+latest_markers[2][i]+' UTC</p></div></font>'
						}
						else{
							string = '<font color=\'black\'>'+'<div id=\'infowindow-title\'><p><b><center><u>End of attempt.</u>'+'</center></b><p></div>'+'<div id=\'infowindow\'>'+'<p><b>Team:</b>'+ team.name+ '&nbsp <b>Robot:</b>'+robot.name +'</p>'+'<p><b>Mission:</b>'+mission.name+' &nbsp; <b>Attempt</b>'+ attempt.name + '</p><p><b>Datetime:</b>'+latest_markers[2][i]+' UTC</p></div></font>'
						}
						var temp = new google.maps.InfoWindow(
							{
								content: string
							}
						);
						addInfoWindow(temp, latest_markers[0][i])
					}
				}
		})
 
	} 
	

	function hideInfoWindow(){
		for(var i=0; i < latest_markers[0].length-1 ; i++){
			//if ((i%10)==0){
				google.maps.event.clearListeners(latest_markers[0][i],'click')
			//}
		}
		google.maps.event.clearListeners(latest_markers[0][latest_markers[0].length-1],'click')
	}

	function addInfoWindow(infowindow,marker){
		// alert(infowindow.length)
		// alert(marker.length)
				google.maps.event.addListener(marker, 'click', function(event) {
					var lat=event.latLng.lat()
					var lng=event.latLng.lng()
					myString='<font color=\'black\'><div>'+'<b>Latitude: </b>'+lat+'&nbsp;'+'<b>Longitude: </b>'+lng+'</div>'+'</font>'
					infowindow.content+=myString
					infowindow.open(replay_map,marker);
				});
	}

	//Set the center of the map
	function setCenter(lat, lng){
		map.panTo(new google.maps.LatLng(lat,lng));
	}

//Fit the zoom to see all the displayed points
	function adaptZoom(){
		var bounds = new google.maps.LatLngBounds();
		for(var i=0; i < latest_markers[0].length ; i++){
			bounds.extend(latest_markers[0][i].getPosition());
		}
		replay_map.fitBounds(bounds);
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

