<?php

$app->get('/users', function() {
    echo 'users without parameter';
});

$app->get('/users/:one', function($one) {
    echo "users with parameter: " . $one;
});

$app->get('/users/:one/:two', function($one, $two) {
    echo "users with parameters: " . $one . " " . $two;
});

$app->post('/users', function() use ($app) {
    $uri = $_SERVER['REQUEST_URI'];
    $params = $app->request()->params();
    //echo "hello, world";
    try {
        $dbh = getConnection();

        $stmt = $dbh->prepare('call create_user(?, ?, ?, @o_id)');
        $stmt->bindParam('1', $params['user'], PDO::PARAM_STR);
        $stmt->bindParam('2', $params['password'], PDO::PARAM_STR);
        $stmt->bindParam('3', $params['email'], PDO::PARAM_STR);
        $stmt->execute();

        $output = $dbh->query('select @o_id')->fetch(PDO::FETCH_ASSOC);
        var_dump($output);
    }
    catch (PDOException $e) {
        $error = array("error" => array("text" =>$e->getMessage()));
        echo json_encode($error);
    }
});