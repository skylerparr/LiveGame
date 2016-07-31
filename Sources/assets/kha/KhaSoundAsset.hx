package assets.kha;
@IgnoreCover
class KhaSoundAsset implements SoundAsset {

    @:isVar
    public var data(get, set):Dynamic;

    public function get_data():Dynamic {
        return data;
    }

    public function set_data(value:Dynamic) {
        return this.data = value;
    }

    public function new() {

    }

    public function init():Void {
    }

    public function dispose():Void {
    }

}
