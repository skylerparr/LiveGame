package animation;
import display.BitmapNode;
class SpriteAnimation implements Animation {

    @:isVar
    public var bitmap(get, set): BitmapNode;
    @:isVar
    public var frames(get, set): Array<Frame>;

    @:isVar
    public var frameTime(get, set):UInt;

    public var numFrames(get, null):UInt;

    public var currentFrame: UInt;

    public function get_frameTime():UInt {
        return frameTime;
    }

    public function set_frameTime(value:UInt) {
        return this.frameTime = value;
    }

    public function get_numFrames():UInt {
        return frames.length;
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
            if(currentFrame >= maxFrames()) {
                currentFrame = 0;
            }
            goToFrame();
        }
    }

    public function new() {
    }

    public function init():Void {
        currentFrame = 0;
    }

    public function dispose():Void {
        bitmap = null;
        frames = null;
    }

    public function nextFrame():Void {
        if(currentFrame >= maxFrames()) {
            currentFrame = 0;
        } else {
            ++currentFrame;
        }
        goToFrame();
    }

    public function prevFrame():Void {
        if(currentFrame == 0) {
            currentFrame = maxFrames();
        } else {
            --currentFrame;
        }
        goToFrame();
    }

    public function setFrame(num:UInt):Void {
        currentFrame = num;
        if(currentFrame > maxFrames()) {
            currentFrame = maxFrames();
        }
        goToFrame();
    }

    private inline function maxFrames() {
        return numFrames - 1;
    }

    private inline function goToFrame() {
        var frame: Frame = frames[currentFrame];

        if(frame != null) {
            bitmap.sx = frame.x;
            bitmap.sy = frame.y;
            bitmap.sw = frame.width;
            bitmap.sh = frame.height;
        }
    }
}
