package sound.kha.mocks;

class MockSoundLayer implements SoundLayer {

    @:isVar
    public var volume(get, set):Float;
    @:isVar
    public var allSounds(get, set):Array<SoundHandle>;

    public function set_volume(value:Float) {
        return this.volume = value;
    }

    public function get_volume():Float {
        return volume;
    }

    public function get_allSounds():Array<SoundHandle> {
        return allSounds;
    }

    public function set_allSounds(value:Array<SoundHandle>) {
        return this.allSounds = value;
    }

    public function play():Void {
    }

    public function pause():Void {
    }

    public function resume():Void {
    }

    public function stop():Void {
    }

    public function addSound(sound:SoundHandle):Void {
    }

    public function removeSound(sound:SoundHandle):Void {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function subscribeToVolumeChange(callback:SoundLayer->Void):Void {
    }

    public function unsubscribeFromVolumeChange(callback:SoundLayer->Void):Void {
    }

    public function removeAll():Void {
    }

}