/*
 * Phpiwire: A PHP wrapper for wiringPi
 *
 * @author Andrew Collington, andy@amnuts.com
 * @version 0.2.0
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
    protected board = [];

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

        var ver_model = "", ver_rev = "", ver_maker = "",
            ver_mem = "", ver_overvolted = "";
        var int_model = 0, int_rev = 0, int_maker = 0,
            int_mem = 0, int_overvolted = 0;

        %{
            char mb[7];
            int model, rev, maker, mem, overVolted;
            piBoardId(&model, &rev, &mem, &maker, &overVolted);
            ZVAL_STRING(ver_model, (char *)piModelNames[model], 1);
            ZVAL_STRING(ver_rev, (char *)piRevisionNames[rev], 1);
            ZVAL_STRING(ver_maker, (char *)piMakerNames[maker], 1);
            sprintf(mb, "%dMB", piMemorySize[mem]);
            ZVAL_STRING(ver_mem, mb, 1);
            ZVAL_BOOL(ver_overvolted, overVolted);
            ZVAL_LONG(&int_model, model);
            ZVAL_LONG(&int_rev, rev);
            ZVAL_LONG(&int_maker, maker);
            ZVAL_LONG(&int_mem, mem);
            ZVAL_LONG(&int_overvolted, overVolted);
        }%

        let this->board = [
            "model"      : ["val" : int_model,      "desc" : ver_model ],
            "revision"   : ["val" : int_rev,        "desc" : ver_rev ],
            "memory"     : ["val" : int_mem,        "desc" : ver_mem ],
            "maker"      : ["val" : int_maker,      "desc" : ver_maker ],
            "overvolted" : ["val" : int_overvolted, "desc" : ver_overvolted ]
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
        return [
            "model"      : this->board["model"]["desc"],
            "revision"   : this->board["revision"]["desc"],
            "memory"     : this->board["memory"]["desc"],
            "maker"      : this->board["maker"]["desc"],
            "overvolted" : this->board["overvolted"]["desc"]
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

