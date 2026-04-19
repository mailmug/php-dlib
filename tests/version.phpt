--TEST--
Just test php extension version
--SKIPIF--
<?php if (!extension_loaded("php_dlib")) print "skip"; ?>
--FILE--
<?php
var_dump(phpversion('php_dlib'));
?>
--EXPECT--
string(5) "1.1.0"