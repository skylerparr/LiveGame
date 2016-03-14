package animation;
import core.BaseObject;
interface Animation extends BaseObject {

    /**
     * delay between frames
     */
    var frameTime(get, set): UInt;
    var numFrames(get, null): UInt;

    function nextFrame(): Void;
    function prevFrame(): Void;
    function setFrame(num: UInt): Void;
}
