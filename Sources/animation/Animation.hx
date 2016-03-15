package animation;
import animation.spec.TexturePackerJSONArrayFrameSpec.Frame;
import display.BitmapNode;
import core.BaseObject;
interface Animation extends BaseObject {

    public var bitmap(get, set): BitmapNode;
    public var frames(get, set): Array<Frame>;

    /**
     * delay between frames
     */
    var frameTime(get, set): UInt;
    var numFrames(get, null): UInt;

    function nextFrame(): Void;
    function prevFrame(): Void;
    function setFrame(num: UInt): Void;
}
