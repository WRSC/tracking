
	
google.load("visualization", "1", {packages:["orgchart"]});
google.setOnLoadCallback(drawChart);

function drawChart() {
			
					$("#draw-chart").click()
					$("#draw-chart").bind('ajax:success', function(evt, teaminfo, status, xhr){
						alert(teaminfo[0].name)
						alert(teaminfo[1].length)
						alert(teaminfo[2].length)
   					var data = new google.visualization.DataTable();
					data.addColumn('string', 'Name');
      		data.addColumn('string', 'Manager');
      		data.addColumn('string', 'ToolTip');

					data.addRows([
						[{v:'Robot', f:'Robot<div style="color:red; font-style:italic">President</div>'}, '', 'The President'],
						[{v:'Mission 1', f:'Mission 1<div style="color:red; font-style:italic">Vice President</div>'}, 'Robot', 'VP'],
						['Mission 2', 'Robot', ''],
						['Mission 3', 'Robot', ''],
						['Mission 4', 'Robot', ''],
						['Bob', 'Mission 1', 'Bob Sponge'],
						['Carol', 'Bob', '']
					]);

					var chart = new google.visualization.OrgChart(document.getElementById('chart_div'));
					chart.draw(data, {allowHtml:true});
  })
			
					
						       
					
    
    }





 
    
