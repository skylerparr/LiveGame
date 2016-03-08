package display.two.kha;
class KhaBitmapNode extends TwoDimDisplayNode implements BitmapNode {

    @:isVar
    public var imageData(get, set):Dynamic;

    @:isVar
    public var sx(get, set):UInt;

    @:isVar
    public var sy(get, set):UInt;

    @:isVar
    public var sw(get, set):UInt;

    @:isVar
    public var sh(get, set):UInt;

    public function new() {
        super();
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
        width = value;
        return this.sw = value;
    }

    function get_sw():UInt {
        return sw;
    }

    function set_sh(value:UInt): UInt {
        height = value;
        return this.sh = value;
    }

    function get_sh():UInt {
        return sh;
    }


}
