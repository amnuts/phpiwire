/*
 * Phpiwire: A PHP wrapper for wiringPi
 *
 * @author Andrew Collington, andy@amnuts.com
 * @version 0.0.1
 * @link https://github.com/amnuts/phpiwire
 * @license MIT, http://acollington.mit-license.org/
 *
 * Pin control
 *
 * Further information about the intricacies of the pin modes, where they can
 * and cannot be used, etc., can be found on the wiringpi website.
 *
 * @see <http://wiringpi.com/reference/core-functions/>
 * @see <http://wiringpi.com/reference/raspberry-pi-specifics/>
 */

namespace Phpiwire;

%{
#include <wiringPi.h>
}%

class Pin
{
    // read/write types
    const DIGITAL = 0;
    const ANALOG  = 1;
    const PWM     = 2;
    // pin modes
    const INPUT   = 0;
    const OUTPUT  = 1;
    const PWM_OUT = 2;
    const CLOCK   = 3;
    // pud modes
    const OFF     = 0;
    const DOWN    = 1;
    const UP      = 2;
    // values
    const LOW     = 0;
    const HIGH    = 1;

    protected id { get };
    protected board { get };
    protected mode = null;
    protected modeName = [];

    /**
     * Initialize the Pin class
     */
    public function __construct(int! pin, <Phpiwire\Board> board)
    {
        let this->id = pin;
        let this->board = board;
        let this->modeName = [
            self::INPUT   : "Input",
            self::OUTPUT  : "Output",
            self::PWM_OUT : "PWM output",
            self::CLOCK   : "GPIO clock"
        ];
    }

    /**
     * String representation of the pin
     *
     * @return string
     */
    public function __toString()
    {
        return "Pin " . this->id . ", mode: " . this->is(true) . "\n"
            . "Digital value: " . this->digitalRead()
            . ", Analog value: " . this->analogRead() . "\n";
    }

    /**
     * Set pin mode
     *
     * @param int
     */
    public function mode(int! mode)
    {
        if !in_array(mode, [self::INPUT, self::OUTPUT, self::PWM_OUT, self::CLOCK]) {
            throw new \Exception("Pin mode not supported");
        }

        %{
            zval *pinnum;
            zephir_read_property_this(&pinnum, this_ptr, SL("id"), PH_NOISY_CC);
            pinMode(Z_LVAL_P(pinnum), mode);
        }%

        let this->mode = mode;
        return this;
    }

    /**
     * Get the pin mode
     *
     * @param bool Return the value as a string
     */
    public function is(bool! asString = false)
    {
        return (asString ? this->modeName[this->mode] : this->mode);
    }

    /**
     * Sets the pull-up or pull-down resistor mode on the pin.
     *
     * The mode can either be OFF, (no pull up/down), DOWN (pull to ground)
     * or UP (pull to 3.3v). The internal pull up/down resistors have a value
     * of approximately 50KΩ on the Raspberry Pi.
     *
     * @param int
     */
    public function pudMode(int! mode)
    {
        if !in_array(mode, [self::OFF, self::DOWN, self::UP]) {
            throw new \Exception("Pull-up/down resistor mode not supported");
        }

        %{
            zval *pinnum;
            zephir_read_property_this(&pinnum, this_ptr, SL("id"), PH_NOISY_CC);
            pullUpDnControl(Z_LVAL_P(pinnum), mode);
        }%

        return this;
    }

    /**
     * Read the value from the pin
     *
     * @param int type Read as digital or analog
     * @return var
     */
    public function read(int! type = self::DIGITAL) -> long
    {
        var value = null;

        %{
            zval *pinnum;
            zephir_read_property_this(&pinnum, this_ptr, SL("id"), PH_NOISY_CC);
            int pin = Z_LVAL_P(pinnum);
        }%

        switch type {
            case self::DIGITAL:
                %{ ZVAL_LONG(value, digitalRead(pin)); }%
                break;
            case self::ANALOG:
                %{ ZVAL_LONG(value, analogRead(pin)); }%
                break;
        }

        return value;
    }

    /**
     * Get digital pin value
     *
     * @return var
     */
    public function digitalRead()
    {
        return this->read(self::DIGITAL);
    }

    /**
     * Get analog pin value
     *
     * @return var
     */
    public function analogRead()
    {
        return this->read(self::ANALOG);
    }

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
     * @param int value
     * @param int type Write digital or analog pin
     * @return void
     */
    public function write(int! value, int! type = self::DIGITAL)
    {
        %{
            zval *pinnum;
            zephir_read_property_this(&pinnum, this_ptr, SL("id"), PH_NOISY_CC);
            int pin = Z_LVAL_P(pinnum);
        }%

        switch type {
            case self::DIGITAL:
                %{ digitalWrite(pin, value); }%
                break;
            case self::ANALOG:
                %{ analogWrite(pin, value); }%
                break;
        }

        return this;
    }

    /**
     * Set digital pin value
     *
     * @return var
     */
    public function digitalWrite(int! value)
    {
        return this->write(value, self::DIGITAL);
    }

    /**
     * Set analog pin value
     *
     * @return var
     */
    public function analogWrite(int! value)
    {
        return this->write(value, self::ANALOG);
    }

    /**
     * Set PWM pin value
     *
     * @return var
     */
    public function pwmWrite(int! value)
    {
        return this->write(value, self::PWM);
    }
}
