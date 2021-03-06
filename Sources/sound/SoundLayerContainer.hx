package sound;
import util.MappedSubscriber;
import core.ObjectCreator;
class SoundLayerContainer implements SoundLayer {

    private inline static var STATE_INIT: Int = 0;
    private inline static var STATE_PLAYING: Int = 1;
    private inline static var STATE_STOPPED: Int = 2;
    private inline static var STATE_PAUSED: Int = 3;

    private inline static var VOLUME_CHANGE: String = "volumeChange";

    @:isVar
    public var volume(get, set):Float;
    public var allSounds(get, null):Array<SoundHandle>;

    @inject
    public var objectCreator: ObjectCreator;
    public var subscriber: MappedSubscriber;
    
    public var currentState: Int = STATE_INIT;

    public function set_volume(value:Float) {
        if(value > 1) {
            value = 1;
        }
        if(value < 0) {
            value = 0;
        }
        setAllVolumes(value);
        return this.volume = value;
    }

    public function get_volume():Float {
        return volume;
    }

    public function get_allSounds():Array<SoundHandle> {
        return allSounds;
    }

    private inline function setAllVolumes(value: Float): Void {
        for(sound in allSounds) {
            sound.volume = value;
        }
        subscriber.notify(VOLUME_CHANGE, [this]);
    }

    public function new() {
    }

    public function init():Void {
        allSounds = [];
        subscriber = objectCreator.createInstance(MappedSubscriber);
        volume = 1;
    }

    public function dispose():Void {
        removeAll();
        objectCreator.disposeInstance(subscriber);
        objectCreator = null;
        subscriber = null;
        allSounds = null;
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

    public function removeAll():Void {
        while(allSounds.length > 0) {
            removeSound(allSounds[0]);
        }
    }

    public function subscribeToVolumeChange(callback:SoundLayer->Void):Void {
        subscriber.subscribe(VOLUME_CHANGE, callback);
    }

    public function unsubscribeFromVolumeChange(callback:SoundLayer->Void):Void {
        subscriber.unsubscribe(VOLUME_CHANGE, callback);
    }

}
