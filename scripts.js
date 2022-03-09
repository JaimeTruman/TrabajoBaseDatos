
async function llenar(){
	fetch("http://localhost/php/index.php", { method: 'GET' }).then(res => {
		res.json().then(res => {
			document.getElementById('table').innerHTML += '<th>Base datos</th><th>Columna</th> <th>Tipo de dato</th>';
			
			for(let item of res.dictionary){
				let tableName = item.tables.name_table;
					
				for(let field of item.tables.fields){
					let name = field.column_name;
					let type = field.data_type;
					
					document.getElementById('table').innerHTML += '<td style="text-align: center;">'+tableName+'</td><td style="text-align: center;">'+name+'</td><td style="text-align: center;">'+type+'</td>';
				}
							
				document.getElementById('table').innerHTML += '<br>';
			}
		});
	});
}