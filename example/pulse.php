<?php

/**
 * Phpiwire: A PHP wrapper for wiringPi
 *
 * Example of using hardware PWM to pulse an LED.
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

echo "Raspberry Pi pulse - use ^C to stop\n";

$pi = new Board();
$p = $pi->getPin(1)->mode(Pin::PWM_OUT);
$p->pwmWrite(0);

$sleep = 500;
$pwmValue = 1024; // 0 min, 1024 max

while (true) {
    for ($i = 0; $i <= $pwmValue; ++$i) {
        $p->pwmWrite($i);
        usleep($sleep);
    }
    sleep(1);
    for ($i = $pwmValue; $i > 0; --$i) {
        $p->pwmWrite($i);
        usleep($sleep);
    }
}
