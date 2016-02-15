<?
ini_set('error_reporting', E_ALL);
ini_set('display_errors',true);

$filename = "lexicon.txt";
//append to file
$file = fopen($filename,"a");

$t1x1 = $_GET['t1x1'];
$t1y1 = $_GET['t1y1'];
$t1x2 = $_GET['t1x2'];
$t1y2 = $_GET['t1y2'];
$t1x3 = $_GET['t1x3'];
$t1y3 = $_GET['t1y3'];
$t2x1 = $_GET['t2x1'];
$t2y1 = $_GET['t2y1'];
$t2x2 = $_GET['t2x2'];
$t2y2 = $_GET['t2y2'];
$t2x3 = $_GET['t2x3'];
$t2y3 = $_GET['t2y3'];

fwrite($file,"\n$t1x1,$t1y1,$t1x2,$t1y2,$t1x3,$t1y3,$t2x1,$t2y1,$t2x2,$t2y2,$t2x3,$t2y3");
fclose($file);
?>
