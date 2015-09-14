<?php

/**
 * Phpiwire: A PHP wrapper for wiringPi
 *
 * Example of blinking an LED connected to pin 0
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

set_time_limit(0);

echo "Raspberry Pi blink - use ^C to stop\n";

$pi = new Board();
$p = $pi->getPin(0)->mode(Pin::OUTPUT);

while (true) {
    echo "\033[1K\rON";
    $p->write(Pin::HIGH);
    sleep(1);
    echo "\033[1K\rOFF";
    $p->write(Pin::LOW);
    sleep(1);
}
