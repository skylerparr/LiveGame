package sound.kha.mocks;

class AudioChannel {

    @:isVar
    public var finished(get, set):Bool;
    @:isVar
    public var length(get, set):Float;
    @:isVar
    public var position(get, set):Float;
    @:isVar
    public var volume(get, set):Float;

    public function get_finished():Bool {
        return finished;
    }

    public function set_finished(value:Bool) {
        return this.finished = value;
    }

    public function set_length(value:Float) {
        return this.length = value;
    }

    public function get_length():Float {
        return length;
    }

    public function set_position(value:Float) {
        return this.position = value;
    }

    public function get_position():Float {
        return position;
    }

    public function set_volume(value:Float) {
        return this.volume = value;
    }

    public function get_volume():Float {
        return volume;
    }

    public function new() {
    }

    public function pause():Void {

    }

    public function play():Void {

    }

    public function stop ():Void {

    }
}