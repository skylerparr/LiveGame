package world.two;
import display.DisplayNodeContainer;
import constants.EventNames;
import util.Subscriber;
import util.EventNotifier;
import display.DisplayNode;
import geom.Rectangle;
class ViewPort2D implements ViewPort {

    @inject
    public var notifier: EventNotifier;
    @inject
    public var subscriber: Subscriber;

    @:isVar
    public var height(get, set):Float;

    @:isVar
    public var width(get, set):Float;

    @:isVar
    public var x(get, set):Float;

    @:isVar
    public var y(get, set):Float;

    @:isVar
    public var z(get, set):Float;

    @:isVar
    public var scale(get, set):Float;

    public var dimension(get, null):Rectangle;

    public var container(get, null): DisplayNodeContainer;

    public function new(container: DisplayNodeContainer) {
        this.container = container;
    }

    public function init():Void {
        this.dimension = new Rectangle();
    }

    public function dispose():Void {
        dimension = null;
        container = null;
        notifier = null;
        subscriber = null;
    }

    function get_container():DisplayNodeContainer {
        return container;
    }

    public function get_height():Float {
        return height;
    }

    public function get_width():Float {
        return width;
    }

    public function set_height(value:Float) {
        this.height = value;
        dimension.height = value;
        notifier.notify(EventNames.VIEW_PORT_RESIZED, null);
        return this.height;
    }

    public function set_width(value:Float) {
        this.width = value;
        dimension.width = value;
        notifier.notify(EventNames.VIEW_PORT_RESIZED, null);
        return this.width;
    }

    public function get_x():Float {
        return x;
    }

    public function set_x(value:Float) {
        this.x = value;
        container.x = -value;
        dimension.x = value;
        notifier.notify(EventNames.VIEW_PORT_TRANSLATED, null);
        return this.x;
    }

    public function set_y(value:Float) {
        this.y = value;
        container.y = -value;
        dimension.y = value;
        notifier.notify(EventNames.VIEW_PORT_TRANSLATED, null);
        return this.y;
    }

    public function get_y():Float {
        return y;
    }

    public function set_z(value:Float) {
        return 0;
    }

    public function get_z():Float {
        return 0;
    }

    public function get_scale():Float {
        return scale;
    }

    public function set_scale(value:Float) {
        return this.scale = value;
    }

    public function get_dimension():Rectangle {
        return dimension;
    }

    public function isInViewableRegion(value:DisplayNode):Bool {
        return true;
    }

    public function subscribeToTranslate(listener: Void->Void):Void {
        subscriber.subscribe(EventNames.VIEW_PORT_TRANSLATED, listener);
    }

    public function unsubscribeToTranslate(listener: Void->Void):Void {
        subscriber.unsubscribe(EventNames.VIEW_PORT_TRANSLATED, listener);
    }

    public function subscribeToResize(listener: Void->Void):Void {
        subscriber.subscribe(EventNames.VIEW_PORT_RESIZED, listener);
    }

    public function unsubscribeToResize(listener: Void->Void):Void {
        subscriber.unsubscribe(EventNames.VIEW_PORT_RESIZED, listener);
    }

}
