package display.two;
class TwoDimDisplayNode implements DisplayNode {

    public var x(default, default): Float;

    public var y(default, default): Float;

    public var z(default, default): Float;

    public var width(default, default): Float;

    public var height(default, default): Float;

    public var depth(default, default): Float;

    public var scaleX(default, default): Float;

    public var scaleY(default, default): Float;

    public var scaleZ(default, default): Float;

    public var name(default, default): String;

    public var parent(get, null):DisplayNodeContainer;

    public var _private_parent: DisplayNodeContainer;

    public function new() {
    }

    private function get_parent():DisplayNodeContainer {
        return _private_parent;
    }

    public function init():Void {
    }

    public function dispose():Void {
        name = null;
    }

}
