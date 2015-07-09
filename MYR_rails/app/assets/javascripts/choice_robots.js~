//=require choice_onerobot

//-----------INITIALIZATION--------------------------------------------
function run_choice_robots(){
	var c=0
	$(document).ready(function(){
		var d = 0;
		  //initialize the checkboxs
		// FOR NOW => si pas de cookie -> rien n est coché
		$( "input[name*='robot']" ).each(function () {
		  var id = $(this).attr('id');
		  var str = $.cookie("robotslist");
		  var tab = str.split(",");
	    //index de l'élément à retirer
	    var index = tab.indexOf(id);
	    if(index > -1){
	      $(this).prop('checked',true);
	      c=c+1;
	    }
	    else{
	      $(this).prop('checked',false);
	    }
		})

		if (c==1){
				//quand on coche une checkbox pour la premiere fois
				requestRefreshOnerobot(true);//affiche le volet pour missions tries
		}else if (c > 1){
			requestRefreshDatetimes();
		}else{}
		
	})

//-------------------  ACTIONS OF THE CHECKBOXES -------------------------------
//pour toutes les checkboxes
  $( "input[name*='robot']" ).each(function () {
    //si on clique dessus
    $(this).click(function() {
      //récupére l'id de la checkbox
      var id = $(this).attr('id');
      //si coché
      if($(this).is(':checked')){
        addrobot(id);
        c=c+1;
      }
      //si décoché
      else{
        rmvrobot(id);
        c=c-1;
      }
      
			if (c==1){
				//quand on coche une checkbox pour la premiere fois
				requestRefreshOnerobot(true)//affiche le volet pour missions tries
			}else if (c > 1){
				requestRefreshDatetimes();
			}
			else if (c==0){
				requestRefreshOnerobot(false);
			} 
    })
  })  
}

function requestRefreshDatetimes(){
		$.ajax({
		type: "GET",
		url: "/choice_datetimes",
		
		success: function(){
			choose_datetimes()
		}       
	});
}
//------------------------------------------------------------------------------------------------
//---------------------------------BEGIN DATETIMES -----------------------------------------------
function getstartselectedvalue(){
	var year = $("#start_year option:selected").val();
	var month =$("#start_month option:selected").val();
	var day =$("#start_day option:selected").val();
	var hour =$("#start_hour option:selected").val();
	var minute =$("#start_minute option:selected").val();
	// convert "8" to "08"
	if(month<10){
		var month = "0"+month;
	}
	if(day<10){
		var day = "0"+day;
	}
	var result = year+month+day+hour+minute;
	return result;
}

function getendselectedvalue(){
	var year = $("#end_year option:selected").val();
	var month =$("#end_month option:selected").val();
	var day =$("#end_day option:selected").val();
	var hour =$("#end_hour option:selected").val();
	var minute =$("#end_minute option:selected").val();
	// convert "8" to "08"
	if(month<10){
		var month = "0"+month;
	}
	if(day<10){
		var day = "0"+day;
	}
	var result = year+month+day+hour+minute;
	return result;
}

function fillcookie(start,end){
  $.cookie("rdatetimes",start+"_"+end);
  var date = new Date();
  //expires in 60 minutes (browser time)
  date.setTime(date.getTime() + (60 * 60 * 1000));
  $.cookie("rdatetimes",start+"_"+end,{ expires: date});
}

function readcookie(){
  return $.cookie("rdatetimes");
}

function initialize_datetimes(){
  var str = readcookie();
  if (str != null){
    var tab = str.split("_");

    var start = tab[0];
    var end = tab[1];

    var tabstart = start.split("");
    var tabend = end.split("");

    //datetime for the start
    //YEAR
    var startyear = tabstart[0]+tabstart[1]+tabstart[2]+tabstart[3];
    //MONTH and convert 08 to 8
    if(tabstart[4] == 1){
      var startmonth = tabstart[4]+tabstart[5];
    }
    else{
      var startmonth = tabstart[5];
    }
    //DAY and convert 08 to 8
    if(tabstart[6] == 1 || tabstart[6] == 2 || tabstart[6] == 3){
      var startday = tabstart[6]+tabstart[7];
    }
    else{
      var startday = tabstart[7];
    }
    //HOURS
    var starthour = tabstart[8]+tabstart[9];
    //MINUTES
    var startminute = tabstart[10]+tabstart[11];

    //changing the start datetime
    $("#start_year option[value="+startyear+"]").prop('selected', true);
    $("#start_month option[value="+startmonth+"]").prop('selected', true);
    $("#start_day option[value="+startday+"]").prop('selected', true);
    $("#start_hour option[value="+starthour+"]").prop('selected', true);
    $("#start_minute option[value="+startminute+"]").prop('selected', true);

    //datetime for the end
    //YEAR
    var endyear = tabend[0]+tabend[1]+tabend[2]+tabend[3];
    //MONTH and convert 08 to 8
    if(tabend[4] == 1){
      var endmonth = tabend[4]+tabend[5];
    }
    else{
      var endmonth = tabend[5];
    }
    //DAY and convert 08 to 8
    if(tabend[6] == 1 || tabend[6] == 2 || tabend[6] == 3){
      var endday = tabend[6]+tabend[7];
    }
    else{
      var endday = tabend[7];
    }
    //HOURS
    var endhour = tabend[8]+tabend[9];
    //MINUTES
    var endminute = tabend[10]+tabend[11];

    //changing the end datetime
    $("#end_year option[value="+endyear+"]").prop('selected', true);
    $("#end_month option[value="+endmonth+"]").prop('selected', true);
    $("#end_day option[value="+endday+"]").prop('selected', true);
    $("#end_hour option[value="+endhour+"]").prop('selected', true);
    $("#end_minute option[value="+endminute+"]").prop('selected', true);

  } 
}

//-------------- INITIALIZE ----------------------------------
function choose_datetimes(){
	//alert('enter choose datetimes')
	//si pas de cookie on cret un cookie par defaut
	if (readcookie() == null || readcookie() == ""){
		fillcookie(getstartselectedvalue(),getendselectedvalue());
	}
	//sinon on change les champs selectionnes dans les datetimes
	else{
		initialize_datetimes();
	}
	
	//---------- WHEN CLICKING ON ANY DROPDOWM LIST----------------
	$('select').on("change", function () {
		//change cookie on change
		fillcookie(getstartselectedvalue(),getendselectedvalue());
	});
	requestRefreshUpdateButton(2)
	//-------------------------------------------------------------
}
//------------------------------------------------------------
//---------------------------END DATETIMES---------------------------------------------------

function getDatetimesInfos(){
	datetime=readcookie()
	tabtime=datetime.split("_")	
	requestGatherCoordsBetweenDates(tabtime)
}


//-------------------------------------------------------------------------------
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
