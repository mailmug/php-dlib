--TEST--
Testing CnnFaceDetection constructor without arguments
--SKIPIF--
<?php if (!extension_loaded("php_dlib")) print "skip"; ?>
--FILE--
<?php
try {
	new CnnFaceDetection();
} catch (Error $e) {
	var_dump($e->getMessage());
}
?>
--EXPECTF--
string(%d) "CnnFaceDetection::__construct() expects exactly 1 %s, 0 given"

