<?php

/**
 * Phpiwire: A PHP wrapper for wiringPi
 *
 * Example of using software PWM to rotate through an RGB LED
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

$sleep = 20000;
$rgb = [100, 0, 0];

while (true) {
    for ($dec = 0; $dec < 3; $dec += 1) {
        $inc = $dec == 2 ? 0 : $dec + 1;
        for ($i = 0; $i < 100; $i += 1) {
            $rgb[$dec] -= 1;
            $rgb[$inc] += 1;
            writePins($rgb);
            usleep($sleep);
        }
    }
}

function writePins(array $rgb)
{
    static $pi, $r, $g, $b;
    if ($pi === null) {
        $pi = new Board();
        $r = $pi->getPin(0)->mode(Pin::SOFT_PWM_OUT)->softPwmWrite(100);
        $g = $pi->getPin(1)->mode(Pin::SOFT_PWM_OUT);
        $b = $pi->getPin(2)->mode(Pin::SOFT_PWM_OUT);
    }
    $r->softPwmWrite($rgb[0]);
    $g->softPwmWrite($rgb[1]);
    $b->softPwmWrite($rgb[2]);
}
