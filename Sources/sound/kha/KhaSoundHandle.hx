package sound.kha;
#if test
import util.MappedSubscriber;
import core.ObjectCreator;
import sound.kha.mocks.AudioChannel;
#else
import kha.audio1.AudioChannel;
#end
class KhaSoundHandle implements SoundHandle {

    @inject
    public var objectCreator: ObjectCreator;
    
    @:isVar
    public var volume(get, set):Float;

    @:isVar
    public var position(get, set):Float;

    public var length(get, null):Float;

    private var sound: AudioChannel;
    private var isPlaying: Bool = false;
    private var mappedSubscriber: MappedSubscriber;

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
//        mappedSubscriber = objectCreator.createInstance(MappedSubscriber);
    }

    public function dispose():Void {
    }

    public function play():Void {
        if(isLoadedAndPlaying()) {
            return;
        }
        isPlaying = true;
        sound.play();
    }

    public function pause():Void {
        if(!isPlaying) {
            return;
        }
        isPlaying = false;
        sound.pause();
    }

    public function resume():Void {
        if(isLoadedAndPlaying()) {
            return;
        }
        sound.play();
    }

    private inline function isLoadedAndPlaying():Bool {
        return (sound == null || isPlaying);
    }

    public function stop():Void {
        if(!isPlaying) {
            return;
        }
        sound.stop();
    }

    public function onPlay(callback: Void->Void):Void {
        trace(mappedSubscriber);
//        mappedSubscriber.subscribe("playSound", callback);
    }

    public function onPause(callback: Void->Void):Void {
    }

    public function onStop(callback: Void->Void):Void {
    }

    public function onFinish(callback: Void->Void):Void {
    }

}
