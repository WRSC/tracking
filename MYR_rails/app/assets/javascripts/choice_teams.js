
//-------------------  ACTIONS OF THE CHECKBOXES -------------------------------
//pour toutes les checkboxes
  $( "input[name*='team']" ).each(function () { 
    //si on clique dessus
    $(this).click(function() {
      //récupére l'id de la checkbox
      var id = $(this).attr('id');
      //si coché
      if($(this).is(':checked')){
        addteam(id);
      }
      //si décoché
      else{
        rmvteam(id);
      }
      $("#refreshrobots").click();
      $("#refreshteams").click();
    })
  })  
//-------------------------------------------------------------------------------

//--------------INITIALIZATION-------------------------------------------------
$(document).ready(function(){
  //initialize the checkboxs
  // FOR NOW => si pas de cookie -> rien n est coché
  $( "input[name*='team']" ).each(function () {
    var id = $(this).attr('id');
    var str = $.cookie("teamslist");
    if (str!=null){
      var tab = str.split(",");
    }
    else{
      tab=[];
    }
    //index de l'élément à retirer
    var index = tab.indexOf(id);
    if(index > -1){
      $(this).prop('checked',true);
    }
    else{
      $(this).prop('checked',false);
    }
  })
  //initial display of the page
  //if at least one checkbox is checked
  $( "input[name*='team']" ).each(function () { 
    if($(this).is(':checked')){
      $("#refreshrobots").click();
    }
  })
})