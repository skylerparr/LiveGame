package mocks;

import assets.SoundAsset;
class MockSoundAsset implements SoundAsset {
    @:isVar
    public var soundData(get, set):Dynamic;

    public function set_soundData(value:Dynamic) {
        return this.soundData = value;
    }

    public function get_soundData():Dynamic {
        return soundData;
    }

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

}