package mocks;

import display.BitmapNode;
import animation.Frame;
import animation.AnimationWithEvents;
class MockAnimationWithEvents implements AnimationWithEvents {


    public function init():Void {
    }

    public function dispose():Void {
    }

    public var AnimationController: Dynamic;
    public var AnimationWithEvents: Dynamic;
    public var spec: Dynamic;

    @:isVar
    public var frames(get, set):Array<Frame>;

    @:isVar
    public var numFrames(get, set):UInt;

    public function nextFrame():Void {
    }

    public function prevFrame():Void {
    }

    public function setFrame(num:UInt):Void {
    }

    public function subscribeOnComplete(callback:AnimationWithEvents->Void):Void {
    }

    public function unsubscribeOnComplete(callback:AnimationWithEvents->Void):Void {
    }

    @:isVar
    public var bitmap(get, set):BitmapNode;

    @:isVar
    public var frameTime(get, set):UInt;

    function get_frames():Array<Frame> {
        return frames;
    }

    function set_frames(value:Array<Frame>) {
        return this.frames = value;
    }

    function set_numFrames(value:UInt) {
        return this.numFrames = value;
    }

    function get_numFrames():UInt {
        return numFrames;
    }

    function set_bitmap(value:BitmapNode) {
        return this.bitmap = value;
    }

    function get_bitmap():BitmapNode {
        return bitmap;
    }

    function get_frameTime():UInt {
        return frameTime;
    }

    function set_frameTime(value:UInt) {
        return this.frameTime = value;
    }


    public function new() {
    }
}