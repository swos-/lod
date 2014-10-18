<?php

$app->post('/login', 'login');
$app->get('/login', 'login2');

function login() {
  echo "hello, world";
}

function login2() {
  echo "hello, world 2";
}
