<?php

/**
 * Phpiwire: A PHP wrapper for wiringPi
 *
 * Checking pin status
 *
 * @author Andrew Collington, andy@amnuts.com
 * @version 0.2.0
 * @link https://github.com/amnuts/phpiwire
 * @license MIT, http://acollington.mit-license.org/
 */

namespace Phpiwire;

$pi = new Board();
$p = $pi->getPin(0)->mode(Pin::OUTPUT);

echo $p, "\n";

if ($p->read() == Pin::LOW) {
    echo "Setting {$p->getId()} to HIGH\n\n";
    $p->write(Pin::HIGH);
} else {
    echo "Setting {$p->getId()} to LOW\n\n";
    $p->write(Pin::LOW);
}

echo $p, "\n";
