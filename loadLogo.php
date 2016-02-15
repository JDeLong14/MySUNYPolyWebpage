<?
ini_set('error_reporting', E_ALL);
ini_set('display_errors', true);

$filename = "users.txt";
//append to file
$file = fopen($filename,"a");
$userName = $_GET['x'];
$logoHash = $_GET['y'];
fwrite($file,"$userName,logoHash\n");
fclose($file);
?>
