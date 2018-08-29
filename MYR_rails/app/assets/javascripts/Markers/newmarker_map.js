//----------------------GLOBAL VARIABLES-------------------

var latest_buoys = []; //[0] for buoys and [1] for mission id
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
  controlImage.src = "/icons/expand-icon-small.png";
  controlUI.appendChild(controlImage);

  // Setup the click event listeners: change the class of the map container
  google.maps.event.addDomListener(controlUI, 'click', function() {
  	$("#map-container").toggleClass("fullscreen");
  	google.maps.event.trigger(map, 'resize');
  });
}

/*============== Begin initialize Google Map============================*/
	//Map initialization
	function initializeMap() {
		//reset the global variables
		latest_buoys = [];
		//map options
		var mapOptions = {
			mapTypeId: 'satellite',
			// see config.js if you you want to change the default map center
			center: config.center,
			zoom: config.zoom-2,
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
		map_marker = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

		//add add button in the top right corner of the map to hide the right panel
		var centerControlDiv = document.createElement('div');
		var centerControl = new FullScreenControl(centerControlDiv);
		centerControlDiv.index = 1;
		map_marker.controls[google.maps.ControlPosition.TOP_RIGHT].push(centerControlDiv);
		

	}

function getMyMap(){
	return map_marker;
}


/*============ Clear Google Map================================*/

function eraseMap() {
		//stop displaying the points
		for(var i=0; i < latest_buoys[0].length ; i++){
			latest_buoys[i].setMap(null);
		}
		//reset the global variables
		latest_buoys = [];
	}

/*======== End initialize Google Map===============================*/


	//Set the center of the map
	function setCenter(lat, lng){
		map.panTo(new google.maps.LatLng(lat,lng));
	}

/*======= End initialize Google Map=================================*/

//Fit the zoom to see all the displayed points
	function adaptZoom(){
		var bounds = new google.maps.LatLngBounds();
		for(var i=0; i < latest_buoys.length ; i++){
			bounds.extend(latest_buoys[i].getPosition());
		}
		map_marker.fitBounds(bounds);
	}
	

