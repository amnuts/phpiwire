<?php

/**
 * Phpiwire: A PHP wrapper for wiringPi
 *
 * Part of the ajax example - resetting pins
 *
 * @author Andrew Collington, andy@amnuts.com
 * @version 0.2.0
 * @link https://github.com/amnuts/phpiwire
 * @license MIT, http://acollington.mit-license.org/
 */

namespace Phpiwire;

$pins = [0, 0, 0];

$pi = new Board();
foreach ($pins as $pin => $val) {
    $p = $pi->getPin($pin)->mode(Pin::OUTPUT);
    $p->write(Pin::LOW);
    $pins[$pin] = $p->read();
}

echo json_encode($pins);

