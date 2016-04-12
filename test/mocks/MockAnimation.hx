package mocks;

import animation.Frame;
import animation.Animation;
import display.BitmapNode;
@IgnoreCover
class MockAnimation implements Animation {

    public function init():Void {
    }

    public function dispose():Void {
    }

    @:isVar
    public var bitmap(get, set):BitmapNode;

    @:isVar
    public var frames(get, set):Array<Frame>;

    @:isVar
    public var frameTime(get, set):UInt;

    @:isVar
    public var numFrames(get, null):UInt;

    public function set_bitmap(value:BitmapNode) {
        return this.bitmap = value;
    }

    public function get_bitmap():BitmapNode {
        return bitmap;
    }

    public function get_frames():Array<Frame> {
        return frames;
    }

    public function set_frames(value:Array<Frame>) {
        return this.frames = value;
    }

    public function get_frameTime():UInt {
        return frameTime;
    }

    public function set_frameTime(value:UInt) {
        return this.frameTime = value;
    }

    public function get_numFrames():UInt {
        return numFrames;
    }

    public function new() {
    }

    public function nextFrame():Void {
    }

    public function prevFrame():Void {
    }

    public function setFrame(num:UInt):Void {
    }
}