package sound.kha.mocks;

class MockSoundHandle implements SoundHandle {

    public function play():Void {
    }

    public function pause():Void {
    }

    public function resume():Void {
    }

    public function stop():Void {
    }

    public function subscribeOnPlay(callback:Void -> Void):Void {
    }

    public function subscribeOnPause(callback:Void -> Void):Void {
    }

    public function subscribeOnStop(callback:Void -> Void):Void {
    }

    public function subscribeOnFinish(callback:Void -> Void):Void {
    }

    public function unsubscribeOnPlay(callback:Void -> Void):Void {
    }

    public function unsubscribeOnPause(callback:Void -> Void):Void {
    }

    public function unsubscribeOnStop(callback:Void -> Void):Void {
    }

    public function unsubscribeOnFinish(callback:Void -> Void):Void {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    @:isVar
    public var volume(get, set):Float;

    @:isVar
    public var position(get, set):Float;

    @:isVar
    public var length(get, set):Float;

    public function set_volume(value:Float) {
        return this.volume = value;
    }

    public function get_volume():Float {
        return volume;
    }

    public function set_position(value:Float) {
        return this.position = value;
    }

    public function get_position():Float {
        return position;
    }

    public function set_length(value:Float) {
        return this.length = value;
    }

    public function get_length():Float {
        return length;
    }


}