
//----------------------GLOBAL VARIABLES-------------------
var replay_map=null
var lastDatetime = "10000101";
var latest_markers = [[],[],[]]; //[0] for markers and [1] for tracker id
var known_trackers = [];
var desired_trackers = [];
var showInfo = false;
var doReplay = false;

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
	
	function displayInfoWindow(tstart,tend,singleAttempt){
		var markerTemp = [];
		var tracker_idTemp = 0;
		var datetimeTemp = 0.0;
		var latTemp = 0.0;
		var lngTemp = 0.0;
		var changeInfowindow=[];
		var count = 0;
		for(var i=0; i < latest_markers[0].length-1 ; i++){
			if ((i%10)==0){
				markerTemp.push(latest_markers[0][i]);
				tracker_idTemp = latest_markers[1][i];
				datetimeTemp = latest_markers[2][i];
				latTemp = markerTemp[count].getPosition().lat();
				lngTemp = markerTemp[count].getPosition().lng();
				count = count + 1;
				$.ajax({
								type: "GET",
								url: "/infowindow",
								data: {tracker_id: tracker_idTemp, timestart: tstart, timeend: tend, datetime: datetimeTemp, singleAttempt: singleAttempt, isEnd: false, lat: latTemp, lng:lngTemp},
								dataType: "html",
								success: function(data){
									//alert('change tracker')
									//alert(data)
									var temp = new google.maps.InfoWindow(
										{
											content: data
										}
									);
									changeInfowindow.push(temp);
									var j = 0;
									while (j < 100){
										j=j+1
									}
								}
				})  
			} 
		}

				markerTemp.push(latest_markers[0][latest_markers[0].length-1]);
				tracker_idTemp = latest_markers[1][latest_markers[0].length-1];
				datetimeTemp = latest_markers[2][latest_markers[0].length-1];
				latTemp = markerTemp[markerTemp.length-1].getPosition().lat();
				lngTemp = markerTemp[markerTemp.length-1].getPosition().lng();
				$.ajax({
								type: "GET",
								url: "/infowindow",
								data: {tracker_id: tracker_idTemp, timestart: tstart, timeend: tend, datetime: datetimeTemp, singleAttempt: singleAttempt, isEnd: true, lat: latTemp, lng:lngTemp},
								dataType: "html",
								success: function(data){
									//alert('change tracker')
									//alert(data)
									var temp = new google.maps.InfoWindow(
										{
											content: data
										}
									);
									changeInfowindow.push(temp);
									alert(changeInfowindow.length)
									alert(markerTemp.length)
									var j = 0;
									while (j < 100){
										j=j+1
									}
									alert(changeInfowindow.length)
									alert(markerTemp.length)
									for(var i=0; i < markerTemp.length ; i++){
										addInfoWindow(changeInfowindow[i],markerTemp[i])
									}
								}
				})
 
	} 
	

	function hideInfoWindow(){

	}

	function addInfoWindow(infowindow,marker){
		// alert(infowindow.length)
		// alert(marker.length)
				google.maps.event.addListener(marker, 'click', function(event) {
					var lat=event.latLng.lat()
					var lng=event.latLng.lng()
					myString='<font color=\'black\'><div>'+'<b>Latitude:</b>'+lat+'&nbsp;'+'<b>Longitude</b>'+lng+'</div>'+'</font>'
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

