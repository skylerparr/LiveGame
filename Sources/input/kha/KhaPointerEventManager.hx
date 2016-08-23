package input.kha;
import geom.Rectangle;
import collections.QuadTree;
import haxe.ds.ObjectMap;
import util.MappedSubscriber;
import core.ObjectCreator;
import display.DisplayNode;
class KhaPointerEventManager implements PointerEventManager implements PointingInputSourceListener {

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
        for(sub in subscriber.subscriptions) {
            return;
        }
        objectCreator.disposeInstance(subscriber);
        subscribers.remove(display);
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

    public function onPointerDown(e:PointerEvent):Void {
        notifiyEvent(e, PointerEventType.POINTER_1_DOWN);
    }

    public function onPointerMove(e:PointerEvent):Void {
        notifiyEvent(e, PointerEventType.POINTER_MOVE);
    }

    public function onPointerUp(e:PointerEvent):Void {
        notifiyEvent(e, PointerEventType.POINTER_1_UP);
    }

    public function onPointerClick(e:PointerEvent):Void {
        notifiyEvent(e, PointerEventType.POINTER_1_CLICK);
    }

    public function onPointerRightDown(e:PointerEvent):Void {
        notifiyEvent(e, PointerEventType.POINTER_2_DOWN);
    }

    public function onPointerRightUp(e:PointerEvent):Void {
        notifiyEvent(e, PointerEventType.POINTER_2_UP);
    }

    public function onPointerRightClick(e:PointerEvent):Void {
        notifiyEvent(e, PointerEventType.POINTER_2_CLICK);
    }

    public function onPointerDoubleClick(e:PointerEvent):Void {
        notifiyEvent(e, PointerEventType.POINTER_1_DOUBLE_CLICK);
    }

    public function onScroll(e:PointerEvent):Void {
        notifiyEvent(e, PointerEventType.ZOOM);
    }

    public function onPointerMiddleDown(e:PointerEvent):Void {
        notifiyEvent(e, PointerEventType.POINTER_3_DOWN);
    }

    public function onPointerMiddleUp(e:PointerEvent):Void {
        notifiyEvent(e, PointerEventType.POINTER_3_UP);
    }

    public function onPointerMiddleClick(e:PointerEvent):Void {
        notifiyEvent(e, PointerEventType.POINTER_3_CLICK);
    }

    private inline function notifiyEvent(e: PointerEvent, eventType: PointerEventType): Void {
        var subscriber: MappedSubscriber = subscribers.get(e.target);
        if(subscriber != null) {
            subscriber.notify(eventType + "", [e]);
        }
    }

}
