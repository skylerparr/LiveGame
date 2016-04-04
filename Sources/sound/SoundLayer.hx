package sound;
interface SoundLayer {
    var volume(get, set): Float;

    function play(name: String): SoundHandle;
    function pause(): Void;
    function resume(): Void;
    function stop(): Void;
}
