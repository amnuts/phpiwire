<?php

/**
 * Phpiwire: A PHP wrapper for wiringPi
 *
 * Part of the ajax example - main control switch/router
 *
 * @author Andrew Collington, andy@amnuts.com
 * @version 0.2.0
 * @link https://github.com/amnuts/phpiwire
 * @license MIT, http://acollington.mit-license.org/
 */

$func = null;
if (!empty($_GET['func'])) {
    $func = $_GET['func'];
}

switch ($func) {
    case 'reset':
        echo shell_exec('sudo php ' . __DIR__ . '/_reset.php 2>&1');
        break;
    case 'set':
        echo shell_exec('sudo php ' . __DIR__ . '/_set.php ' . (int)$_GET['pin'] . ' ' . (int)$_GET['onoff'] . ' 2>&1');
        break;
    default:
        echo json_encode(['error' => 'Bad function call']);
        break;
}
