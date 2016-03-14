package animation;
import animation.spec.TexturePackerJSONArrayFrameSpec.Frame;
import display.BitmapNode;
import animation.spec.TexturePackerJSONArrayFrameSpec;
class TP_JSONArraySpriteAnimation implements Animation {

    @:isVar
    public var bitmap(get, set): BitmapNode;
    @:isVar
    public var frames(get, set): Array<Frame>;

    @:isVar
    public var frameTime(get, set):UInt;

    public var numFrames(get, null):UInt;

    private var currentFrame: UInt = 0;

    public function get_frameTime():UInt {
        return frameTime;
    }

    public function set_frameTime(value:UInt) {
        return this.frameTime = value;
    }

    public function get_numFrames():UInt {
        return numFrames;
    }

    public function set_bitmap(value:BitmapNode) {
        this.bitmap = value;
        goToFirstFrame();
        return this.bitmap;
    }

    public function get_bitmap():BitmapNode {
        return bitmap;
    }

    public function get_frames():Array<Frame> {
        return frames;
    }

    public function set_frames(value:Array<Frame>) {
        this.frames = value;
        goToFirstFrame();
        return this.frames;
    }

    private inline function goToFirstFrame():Void {
        if(bitmap != null && frames != null) {
            goToFrame(0);
        }
    }

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function nextFrame():Void {

    }

    public function prevFrame():Void {
    }

    public function setFrame(num:UInt):Void {
    }

    private inline function goToFrame(num: UInt) {
        var frame: Frame = frames[num];

        bitmap.sx = frame.x;
        bitmap.sy = frame.y;
        bitmap.sw = frame.width;
        bitmap.sh = frame.height;
    }
}
