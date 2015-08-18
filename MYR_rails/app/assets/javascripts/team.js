
	
google.load("visualization", "1", {packages:["orgchart"]});
google.setOnLoadCallback(drawChart);

function drawChart() {
				$("#draw-chart").click()
				$("#draw-chart").bind('ajax:success', function(evt, teaminfo, status, xhr){
/*
teaminfo[0] => info about robot
teaminfo[1] => info about missions => [mission,[attempts]]

*/	
				var robname=teaminfo[0].name
				
 				var data = new google.visualization.DataTable();
				data.addColumn('string', 'Name');
    		data.addColumn('string', 'Manager');
    		data.addColumn('string', 'ToolTip');
//============ add robot node ===============
				data.addRows([
					[{v:robname, f:robname+'<div style="color:red; font-style:italic">President</div>'}, '', 'Your Robot']
				]);
//============ add mission node =================

				for (var i=0;i<teaminfo[1].length;i++){
// teaminfo[i] = [mission,[attempts]]
					m=teaminfo[1][i][0]
					data.addRows([
						[{v:m.name, f:m.name+'<div style="color:red; font-style:italic">Vice President</div>'}, robname, 'Mission '+m.id],
					]);
					atts=teaminfo[1][i][1]
					for (var j=0; j< atts.length;j++){
							data.addRows([
								[atts[j].name, m.name, 'Attempt'],
								['Tracker '+atts[j].tracker_id, atts[j].name, 'Tracker']
					]);	
					}
				}
				var option={
					allowHtml:true,
					size: 'large'
				}
				var chart = new google.visualization.OrgChart(document.getElementById('chart_div'));
				chart.draw(data, option);
			})
	    
}





 
    
