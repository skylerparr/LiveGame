package display;
import core.BaseObject;
interface DisplayNode extends BaseObject {
    var x(get, set): Float;
    var y(get, set): Float;
    var z(get, set): Float;
    var width(get, set): Float;
    var height(get, set): Float;
    var depth(get, set): Float;
    var scaleX(get, set): Float;
    var scaleY(get, set): Float;
    var scaleZ(get, set): Float;
    var name(get, set): String;

    var parent(get, null): DisplayNodeContainer;
}
