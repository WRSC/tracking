//-------------------  ACTIONS OF THE CHECKBOXES -------------------------------
//pour toutes les checkboxes
  var c = 0;
  $( "input[name*='robot']" ).each(function () {  
    //si on clique dessus
    $(this).click(function() {
      //récupére l'id de la checkbox
      var id = $(this).attr('id');
      //si coché
      if($(this).is(':checked')){
        addrobot(id);
      }
      //si décoché
      else{
        rmvrobot(id);
      }
      if (c==0){
        //quand on coche une checkbox pour la premiere fois
        $("#updatemap").click(); //affiche le champ update
        c=1;
      }
      
    })
  })

//-------------------------------------------------------------------------------

//-----------INITIALIZATION--------------------------------------------

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
      }
      else{
        $(this).prop('checked',false);
      }
    })
  //initial display of the page
  //if at least one checkbox is checked
  $( "input[name*='robot']" ).each(function () { 
    if($(this).is(':checked')){
      if (d==0){//update la map si UNE case est coché
        $("#updatemapp").click();
        d=1;
      }
    }
  })  
})
//-------------------------------------------------------------------------------
