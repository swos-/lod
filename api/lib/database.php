<?php

require_once('api/conf/db.conf');

function getConnection() {
	$dbh = new PDO("mysql:host=" . DB_HOST . "; dbname=" . DB_DATABASE, DB_USER, DB_PASSWORD);
	$dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	return $dbh;
}