<?php

/**
 * Phpiwire: A PHP wrapper for wiringPi
 *
 * Get the board information
 *
 * @author Andrew Collington, andy@amnuts.com
 * @version 0.0.1
 * @link https://github.com/amnuts/phpiwire
 * @license MIT, http://acollington.mit-license.org/
 */

namespace Phpiwire;

$pi = new Board();
echo $pi, "\n";
var_dump($pi->version());