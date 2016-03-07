package display.two.kha;
class KhaBitmapNode extends TwoDimDisplayNode implements BitmapNode {

    public var imageData(get, set):Dynamic;

    public var sx(get, set):UInt;

    public var sy(get, set):UInt;

    public var sw(get, set):UInt;

    public var sh(get, set):UInt;

    public function new() {
    }

    function get_imageData():Dynamic {
        return imageData;
    }

    function set_imageData(value:Dynamic): Dynamic {
        return this.imageData = value;
    }

    function set_sx(value:UInt): UInt {
        return this.sx = value;
    }

    function get_sx():UInt {
        return sx;
    }

    function set_sy(value:UInt): UInt {
        return this.sy = value;
    }

    function get_sy():UInt {
        return sy;
    }

    function set_sw(value:UInt): UInt {
        return this.sw = value;
    }

    function get_sw():UInt {
        return sw;
    }

    function set_sh(value:UInt): UInt {
        return this.sh = value;
    }

    function get_sh():UInt {
        return sh;
    }


}
