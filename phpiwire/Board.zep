/*
 * Phpiwire: A PHP wrapper for wiringPi
 *
 * @author Andrew Collington, andy@amnuts.com
 * @version 0.0.1
 * @link https://github.com/amnuts/phpiwire
 * @license MIT, http://acollington.mit-license.org/
 *
 * Board control
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

class Board
{
    // pin numbering scheme
    const WIRINGPI  = 0;
    const GPIO      = 1;
    const SYSTEM    = 2;
    const PHYSICAL  = 3;
    // pwm mode
    const MARKSPACE = 0;
    const BALANCED  = 1;

    protected scheme;
    protected schemeName = [];

    /**
     *
     */
    public function __construct(int! scheme = self::WIRINGPI)
    {
        this->mode(scheme);
        let this->schemeName = [
            self::WIRINGPI : "WiringPi pin numbers (virtual pin numbers 0 through 16)",
            self::GPIO     : "GPIO pin numbers (direct pin numbers with no re-mapping - different across board revisions)",
            self::SYSTEM   : "System numbers (uses /sys/class/gpio interface but pins first need exporting via gpio)",
            self::PHYSICAL : "Physical pin numbers (the P1 connector only)"
        ];
    }

    /**
     * String representation of the board
     *
     * @return string
     */
    public function __toString()
    {
        var v;
        let v = this->version();

        return "Model: " . v["model"] . " (rev " . v["revision"]
            . ") built by " . v["maker"] . ", " . v["memory"]
            . (v["overvolted"] ? " [OV]" : "") . "\nUsing pin scheme: "
            . this->schemeName[this->scheme];
    }

    /**
     * Set up the board pin configuration
     *
     * @param int
     */
    public function mode(int! scheme)
    {
        int ret = -1;

        let this->scheme = scheme;
        switch scheme {
            case self::WIRINGPI:
                %{ ret = wiringPiSetup(); }%
                break;
            case self::GPIO:
                %{ ret = wiringPiSetupGpio(); }%
                break;
            case self::SYSTEM:
                %{ ret = wiringPiSetupSys(); }%
                break;
            case self::PHYSICAL:
                %{ ret = wiringPiSetupPhys(); }%
                break;
            default:
                throw new \Exception("Pin numbering scheme not supported");
        }

        if ret == -1 {
            throw new \Exception("Could not set board scheme");
        }

        return this;
    }

    /**
     * Get version information about the board
     *
     * @return array
     */
    public function version() -> array
    {
        var ver_model = "", ver_rev = "", ver_maker = "",
            ver_mem = "", ver_overvolted = "";

        %{
            char mb[7];
            int model, rev, maker, mem, overVolted;
            piBoardId(&model, &rev, &mem, &maker, &overVolted);
            ZVAL_STRING(ver_model, (char *)piModelNames[model], 1);
            ZVAL_STRING(ver_rev, (char *)piRevisionNames[rev], 1);
            ZVAL_STRING(ver_maker, (char *)piMakerNames[maker], 1);
            sprintf(mb, "%dMB", mem);
            ZVAL_STRING(ver_mem, mb, 1);
            ZVAL_BOOL(ver_overvolted, overVolted);
        }%

        return [
            "model"      : ver_model,
            "revision"   : ver_rev,
            "memory"     : ver_mem,
            "maker"      : ver_maker,
            "overvolted" : ver_overvolted
        ];
    }

    /**
     * Get the pin numbering scheme
     *
     * @return array
     */
    public function getPinScheme() -> array
    {
        return [
            "scheme"      : this->scheme,
            "description" : this->schemeName[this->scheme]
        ];
    }

    /**
     * Instantiate a Pin class
     *
     * @param int pin The pin number to use
     * @return Pin
     */
    public function getPin(int! pin) -> <Pin>
    {
        return new Pin(pin, this);
    }

    /**
     * Set the mode for the PWM generator.
     *
     * @param int
     */
    public function pwmMode(int! mode)
    {
        if !in_array(mode, [self::BALANCED, self::MARKSPACE]) {
            throw new \Exception("PWM mode not supported");
        }

        %{ pwmSetMode(mode); }%

        return this;
    }

    /**
     * Set the range for the PWM generator.
     *
     * @param int
     */
    public function pwmRange(uint! range = 1024)
    {
        %{ pwmSetRange(range); }%

        return this;
    }

    /**
     * Set the divisor for the PWM clock.
     *
     * @param int
     */
    public function pwmClock(int! divisor)
    {
        %{ pwmSetClock(divisor); }%

        return this;
    }

}

