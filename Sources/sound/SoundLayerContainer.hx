package sound;
class SoundLayerContainer implements SoundLayer {

    private inline static var STATE_INIT: Int = 0;
    private inline static var STATE_PLAYING: Int = 1;
    private inline static var STATE_STOPPED: Int = 2;
    private inline static var STATE_PAUSED: Int = 3;

    @:isVar
    public var volume(get, set):Float;
    public var allSounds(get, null):Array<SoundHandle>;

    public var currentState: Int = STATE_INIT;

    public function set_volume(value:Float) {
        return this.volume = value;
    }

    public function get_volume():Float {
        return volume;
    }

    public function get_allSounds():Array<SoundHandle> {
        return allSounds;
    }

    public function new() {
    }

    public function init():Void {
        allSounds = [];
    }

    public function dispose():Void {
    }

    public inline function isPlaying(): Bool {
        return currentState == STATE_PLAYING;
    }

    public inline function isStopped(): Bool {
        return currentState == STATE_STOPPED;
    }

    public function play():Void {
        if(isPlaying() || isStopped()) {
            return;
        }

        currentState = STATE_PLAYING;
        for(sound in allSounds) {
            sound.play();
        }
    }

    public function pause():Void {
        if(!isPlaying()) {
            return;
        }
        currentState = STATE_PAUSED;
        for(sound in allSounds) {
            sound.pause();
        }
    }

    public function resume():Void {
        if(isPlaying() || isStopped()) {
            return;
        }
        currentState = STATE_PLAYING;
        for(sound in allSounds) {
            sound.resume();
        }
    }

    public function stop():Void {
        if(isStopped()) {
            return;
        }
        currentState = STATE_STOPPED;
        for(sound in allSounds) {
            sound.stop();
        }
    }

    public function addSound(sound:SoundHandle):Void {
        allSounds.push(sound);
        if(currentState == STATE_PLAYING) {
            sound.play();
        }
    }

    public function removeSound(sound:SoundHandle):Void {
        allSounds.remove(sound);
        if(currentState == STATE_PLAYING) {
            sound.pause();
        }
    }

}
