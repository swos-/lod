<?php

session_start();

define('ROUTES', 'api/routes/');
define('LIB', 'api/lib/');
require('api/vendor/autoload.php');
require(LIB . 'database.php');

$app = new \Slim\Slim();

require(ROUTES . 'user.php');
require(ROUTES . 'session.php');

$app->run();
