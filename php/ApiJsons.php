<?php
include_once 'Json.php';

class ApiJsons{
	public function getAll(){
    	$json = new Json(); 	 
    	$res = $json->getJsons();
    	$json_a["items"] = array();
    	if($res->rowCount()){
        	while ($row = $res->fetch(PDO::FETCH_ASSOC)){
            	$item=array(
                	"json" => $row['dictionary']
            	);
            	array_push($json_a["items"], $item);
        	}
       	// echo json_encode($json_a);
       	print_r($json_a['items'][0]['json']);
        	return $json_a['items'][0]['json'];
    	}else{
        	echo json_encode(array('mensaje' => 'No hay elementos'));
    	}
	}
}
?>
