<?php

/**
 * Phpiwire: A PHP wrapper for wiringPi
 *
 * Part of the ajax example - setting pins
 *
 * @author Andrew Collington, andy@amnuts.com
 * @version 0.2.0
 * @link https://github.com/amnuts/phpiwire
 * @license MIT, http://acollington.mit-license.org/
 */

namespace Phpiwire;

$pins = [0, 0, 0];

$pi = new Board();

if (!isset($argv[1]) || !isset($argv[2])) {
    echo json_encode(['error' => 'Incorrect number of parameters']);
} else if ($argv[1] < 0 || $argv[1] > 3) {
    echo json_encode(['error' => 'Incorrect pin numbers selected - only 0-3 valid']);
} else {
    foreach ($pins as $pin => $val) {
        $p = $pi->getPin($pin)->mode(Pin::OUTPUT);
        if ($pin == $argv[1]) {
            $p->write((bool)$argv[2] ? Pin::HIGH : Pin::LOW);
        }
        $pins[$pin] = $p->read();
    }
    echo json_encode($pins);
}
