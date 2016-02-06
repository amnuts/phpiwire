<?php

/**
 * Phpiwire: A PHP wrapper for wiringPi
 *
 * Example of resetting the GPIO pins
 *
 * @author Andrew Collington, andy@amnuts.com
 * @version 0.2.0
 * @link https://github.com/amnuts/phpiwire
 * @license MIT, http://acollington.mit-license.org/
 */

namespace Phpiwire;

if (PHP_SAPI !== 'cli') {
    echo 'Sorry, you can only use this via the command line.';
    return;
}

echo "Raspberry Pi - all pins reset to LOW\n";

$pi = new Board();
foreach (range(0, 7) as $pin) {
    $p = $pi->getPin($pin)->mode(Pin::OUTPUT);
    $p->write(Pin::LOW);
}
