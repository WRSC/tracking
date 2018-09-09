// Js handling the autorefresh option or the manual option

var MYR_auto_refresh_handle = null;

function startAutoRefresh() {
	stopAutoRefresh();  // Reset
	//autoUpdate();
	MYR_auto_refresh_handle = setInterval(function() {
		getNewTrackers();
	}, getRefreshRate());
}

function stopAutoRefresh() {
	if (MYR_auto_refresh_handle !== null) {
		clearInterval(MYR_auto_refresh_handle);
	}
}

// If a mission is selected, start auto refresh or show the manual refresh button
function resetAutoRefresh() {
	var mission_id = $('#dropdown_select_mission :selected').val();
	if (mission_id === "select_mission") {
		stopAutoRefresh();
		$('#requestRefresh').hide();
	} else if ($("#autoRefreshCheckBox").is(':checked')) {
		$('#requestRefresh').hide();
		startAutoRefresh();
	} else {
		stopAutoRefresh();
		$('#requestRefresh').show();
	}
}

// Called on page load to hook up Javascript event handlers
function autorefreshBindEvents() {
	// Button: Manual refresh
	$("#requestRefresh").click(getNewTrackers);

	// Checkbox: Disable/enable autorefresh
	$("#autoRefreshCheckBox").click(resetAutoRefresh);

	// Dropdown: Max coordinates to load
	$("#dropdown_select_maxCoords").change(function(){
		var state = $('#dropdown_select_maxCoords :selected').val();
		setMaxCoords(state);
		saveLastDatetime("10000101");  // Load coordinates again from the start
		eraseMap();
	})
	setMaxCoords($('#dropdown_select_maxCoords :selected').val());

	// Dropdown: Refresh rate
	$("#dropdown_select_refreshRate").change(function(){
		var state = $('#dropdown_select_refreshRate :selected').val();
		if (state<5000){
			alert("/!\\WARNING/!\\\r\nUsing a high refresh rate (below 5s)\r\nmay reduce the performance of the server\r\nand cause bugs.")
		}
		setRefrestRate(state);
		resetAutoRefresh();
	})
	setRefrestRate($('#dropdown_select_refreshRate :selected').val());

	// Dropdown: Load coordinates starting from
	$("#dropdown_select_offset").change(function(){
		var state = $('#dropdown_select_offset :selected').val();
		setOffset(state);
		saveLastDatetime("10000101");  // Load coordinates again from the start
	})
	setOffset($('#dropdown_select_offset :selected').val());
}

//--------------------------------------------------------------------------------------------------
// Fetch newly added coordinates, or load coordinates since begining of mission
function getNewCoordinates(){
	//$("#getNewCoordinates").click( function() {
		$.ajax({
			type: "GET",
			url: "/gatherCoordsSince",
			data: {datetime : getLastDatetime(), trackers: getDesiredTrackers(), mission_id: getCurrentMission(), numCoords: getMaxCoords(), offset: getOffset()},
			dataType: "json",
			success: function(data){
				if(data.length > 0){
					refreshWithNewMarkers2(data,getMyMap());
					//clearDesiredTrackers(getDesiredTrackers()); //need to check
				}
			}       
		});
	//});
}

// Fetch new (or all) trackers in the selected mission
function getNewTrackers(){
	$.ajax({
		type: "GET",
		url: "/getNewTrackers",
		data: {datetime : getLastDatetime(), trackers: getKnownTrackers(), mission_id: getCurrentMission(), numCoords: getMaxCoords(), offset: getOffset()}, //!!!!! Be careful, datetime can not begin with 0
		dataType: "json",
		success: function(data){// retrieve an array containing the not yet known trackers
			if(data.length > 0){
				saveNewDesiredTracker(data);
				saveNewKnownTracker(data);
				loadMissionRobots();
			}
			getNewCoordinates();
		}       
	});
}
