<?php

/**
 * Phpiwire: A PHP wrapper for wiringPi
 *
 * Stub file for PHPStorm to provide introspection
 *
 * @author Andrew Collington, andy@amnuts.com
 * @version 0.2.0
 * @link https://github.com/amnuts/phpiwire
 * @license MIT, http://acollington.mit-license.org/
 */

class Phpiwire
{
    // pin numbering scheme
    const WIRINGPI  = 0;
    const GPIO      = 1;
    const SYSTEM    = 2;
    const PHYSICAL  = 3;
    // pwm mode
    const MARKSPACE = 0;
    const BALANCED  = 1;

    protected $scheme;
    protected $schemeName = [];
    protected $board = [];

    /**
     * @param int $scheme
     */
    public function __construct($scheme = self::WIRINGPI) {}

    /**
     * String representation of the board
     *
     * @return string
     */
    public function __toString() {}

    /**
     * Set up the board pin configuration
     *
     * @param int
     */
    public function mode($scheme) {}

    /**
     * Get version information about the board
     *
     * @return array
     */
    public function version() {}

    /**
     * Get the pin numbering scheme
     *
     * @return array
     */
    public function getPinScheme() {}

    /**
     * Instantiate a Pin class
     *
     * @param int $pin The pin number to use
     * @return Pin
     */
    public function getPin($pin) {}

    /**
     * Set the mode for the PWM generator.
     *
     * @param int
     */
    public function pwmMode($mode) {}

    /**
     * Set the range for the PWM generator.
     *
     * @param int
     */
    public function pwmRange($range = 1024) {}

    /**
     * Set the divisor for the PWM clock.
     *
     * @param int
     */
    public function pwmClock($divisor) {}
}

class Pin
{
    // read/write types
    const DIGITAL  = 0;
    const ANALOG   = 1;
    const PWM      = 2;
    const SOFT_PWM = 3;
    // pin modes
    const INPUT        = 0;
    const OUTPUT       = 1;
    const PWM_OUT      = 2;
    const CLOCK        = 3;
    const SOFT_PWM_OUT = 4;
    // pud modes
    const OFF  = 0;
    const DOWN = 1;
    const UP   = 2;
    // values
    const LOW  = 0;
    const HIGH = 1;

    protected $mode = null;
    protected $modeName = [];

    /**
     * Initialize the Pin class
     * @param $pin
     * @param \Phpiwire\Board $board
     */
    public function __construct($pin, Phpiwire\Board $board) {}

    /**
     * String representation of the pin
     *
     * @return string
     */
    public function __toString() {}

    /**
     * Get the id of the pin
     */
    public function getId() {}

    /**
     * Get the board object
     */
    public function getBoard() {}

    /**
     * Set pin mode
     *
     * @param int
     */
    public function mode($mode) {}

    /**
     * Get the pin mode
     *
     * @param bool $asString Return the value as a string
     */
    public function is($asString = false) {}

    /**
     * Sets the pull-up or pull-down resistor mode on the pin.
     *
     * The mode can either be OFF, (no pull up/down), DOWN (pull to ground)
     * or UP (pull to 3.3v). The internal pull up/down resistors have a value
     * of approximately 50KΩ on the Raspberry Pi.
     *
     * @param int
     */
    public function pudMode($mode) {}

    /**
     * Read the value from the pin
     *
     * @param int $type Read as digital or analog
     * @return int
     */
    public function read($type = self::DIGITAL) {}

    /**
     * Get digital pin value
     *
     * @return int
     */
    public function digitalRead() {}

    /**
     * Get analog pin value
     *
     * @return int
     */
    public function analogRead() {}

    /**
     * Write a value to the pin.
     *
     * With DIGITAL, value is either high (1) or low (0).  Any non-zero value
     * is considered high, but only 0 is considered low.
     *
     * With PWM, the Raspberry Pi has one on-board PWM pin - pin 1, 18 or 12
     * depending on whether you're using the wiringpi numbering scheme, or
     * GPIO, or physical (respectively).  Not available in system mode.
     *
     * @param int $value
     * @param int $type Write digital or analog pin
     * @return $this
     */
    public function write($value, $type = self::DIGITAL) {}

    /**
     * Set digital pin value
     *
     * @param $value
     * @return $this
     */
    public function digitalWrite($value) {}

    /**
     * Set analog pin value
     *
     * @param $value
     * @return $this
     */
    public function analogWrite($value) {}

    /**
     * Set PWM pin value
     *
     * @param $value
     * @return $this
     */
    public function pwmWrite($value) {}

    /**
     * Set PWM pin value
     *
     * @param $value
     * @return $this
     */
    public function softPwmWrite($value) {}
}
