package input.kha;
import geom.Rectangle;
import collections.QuadTree;
import haxe.ds.ObjectMap;
import util.MappedSubscriber;
import core.ObjectCreator;
import display.DisplayNode;
class KhaPointerEventManager implements PointerEventManager {

    @inject
    public var objectCreator: ObjectCreator;

    public var subscribers: ObjectMap<DisplayNode, MappedSubscriber>;

    public function new() {
    }

    public function init():Void {
        subscribers = new ObjectMap<DisplayNode, MappedSubscriber>();
    }

    public function dispose():Void {
        for(subscriber in subscribers) {
            objectCreator.disposeInstance(subscriber);
        }
        objectCreator = null;
        subscribers = null;
    }

    public function registerEvent(display:DisplayNode, type:PointerEventType, handler:PointerEvent->Void):Void {
        if(display == null || type == null || handler == null) {
            return;
        }
        var subscriber: MappedSubscriber = getSubscriber(display);
        subscriber.subscribe(type + "", handler);
        subscribers.set(display, subscriber);
    }

    public function unregisterEvent(display:DisplayNode, type:PointerEventType, handler:PointerEvent->Void):Void {
        var subscriber: MappedSubscriber = getSubscriber(display);
        subscriber.unsubscribe(type + "", handler);
    }

    private inline function getSubscriber(display: DisplayNode): MappedSubscriber {
        var subscriber: MappedSubscriber = subscribers.get(display);
        if(subscriber == null) {
            subscriber = objectCreator.createInstance(MappedSubscriber);
        }
        return subscriber;
    }

    public function unregisterAll(display:DisplayNode):Void {
        var subscriber: MappedSubscriber = subscribers.get(display);
        if(subscriber != null) {
            objectCreator.disposeInstance(subscriber);
        }
        subscribers.remove(display);
    }

}
