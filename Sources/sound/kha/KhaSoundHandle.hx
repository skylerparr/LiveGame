package sound.kha;
#if test
import util.MappedSubscriber;
import core.ObjectCreator;
import sound.kha.mocks.AudioChannel;
#else
import kha.audio1.AudioChannel;
#end
class KhaSoundHandle implements SoundHandle {

    private inline static var EVENT_PLAY: String = "soundPlay";
    private inline static var EVENT_STOP: String = "soundStop";
    private inline static var EVENT_PAUSE: String = "soundPause";
    private inline static var EVENT_FINISH: String = "soundFinish";

    private inline static var STATE_INIT: Int = 0;
    private inline static var STATE_PLAYING: Int = 1;
    private inline static var STATE_STOPPED: Int = 2;
    private inline static var STATE_PAUSED: Int = 3;
    private inline static var STATE_FINISHED: Int = 4;

    @inject
    public var objectCreator: ObjectCreator;
    
    @:isVar
    public var volume(get, set):Float;

    @:isVar
    public var position(get, set):Float;

    public var length(get, null):Float;

    public var sound: AudioChannel;
    public var mappedSubscriber: MappedSubscriber;

    public var currentState: Int = STATE_INIT;

    public function new(sound: AudioChannel) {
        this.sound = sound;
    }

    public function set_volume(value:Float) {
        if(sound == null) {
            return 0.0;
        }
        if(value > 1) {
            value = 1;
        }
        if(value < 0) {
            value = 0;
        }
        return sound.volume = value;
    }

    public function get_volume():Float {
        if(sound == null) {
            return 0;
        }
        return sound.volume;
    }

    public function set_position(value:Float): Float {
        if(sound == null) {
            return 0;
        }
        return sound.position;
    }

    public function get_position():Float {
        if(sound == null) {
            return 0;
        }
        return sound.position;
    }

    public function get_length():Float {
        if(sound == null) {
            return 0;
        }
        return sound.length;
    }

    public function init():Void {
        mappedSubscriber = objectCreator.createInstance(MappedSubscriber);
        volume = 1;
    }

    public function dispose():Void {
    }

    public function play():Void {
        if(isLoadedAndPlaying()) {
            return;
        }
        currentState = STATE_PLAYING;
        sound.play();
        mappedSubscriber.notify(EVENT_PLAY, null);
    }

    public function pause():Void {
        if(!isPlaying()) {
            return;
        }
        currentState = STATE_PAUSED;
        sound.pause();
        mappedSubscriber.notify(EVENT_PAUSE, null);
    }

    public function resume():Void {
        if(isLoadedAndPlaying() || currentState == STATE_INIT) {
            return;
        }
        currentState = STATE_PLAYING;
        sound.play();
        mappedSubscriber.notify(EVENT_PLAY, null);
    }

    public function stop():Void {
        if(!isPlaying()) {
            return;
        }
        currentState = STATE_STOPPED;
        sound.stop();
        sound = null;
        mappedSubscriber.notify(EVENT_STOP, null);
    }

    private inline function isLoadedAndPlaying():Bool {
        return sound == null || isPlaying();
    }

    private inline function isPlaying(): Bool {
        return currentState == STATE_PLAYING;
    }

    public function subscribeOnPlay(callback:Void -> Void):Void {
        mappedSubscriber.subscribe(EVENT_PLAY, callback);
    }

    public function subscribeOnPause(callback:Void -> Void):Void {
        mappedSubscriber.subscribe(EVENT_PAUSE, callback);
    }

    public function subscribeOnStop(callback:Void -> Void):Void {
        mappedSubscriber.subscribe(EVENT_STOP, callback);
    }

    public function subscribeOnFinish(callback:Void -> Void):Void {
        mappedSubscriber.subscribe(EVENT_FINISH, callback);
    }

    public function unsubscribeOnPlay(callback:Void -> Void):Void {
        mappedSubscriber.unsubscribe(EVENT_PLAY, callback);
    }

    public function unsubscribeOnPause(callback:Void -> Void):Void {
        mappedSubscriber.unsubscribe(EVENT_PAUSE, callback);
    }

    public function unsubscribeOnStop(callback:Void -> Void):Void {
        mappedSubscriber.unsubscribe(EVENT_STOP, callback);
    }

    public function unsubscribeOnFinish(callback:Void -> Void):Void {
        mappedSubscriber.unsubscribe(EVENT_FINISH, callback);
    }

    public function onUpdate(): Void {
        if(sound != null && sound.finished && currentState != STATE_FINISHED) {
            currentState = STATE_FINISHED;
            sound = null;
            mappedSubscriber.notify(EVENT_FINISH, null);
        }
    }

}
