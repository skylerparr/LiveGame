package util;
class MappedSubscriber implements Subscriber implements EventNotifier {

    public var subscriptions: Map<String, Array<Dynamic>>;

    public function new() {

    }

    public function init():Void {
        subscriptions = new Map<String, Array<Dynamic>>();
    }

    public function dispose():Void {

    }

    public function subscribe(event:String, handler: Dynamic):Void {
        if(event == null || handler == null) {
            return;
        }
        var handlers: Array<Dynamic> = subscriptions.get(event);
        if(handlers == null) {
            handlers = [];
        }
        handlers.push(handler);
        subscriptions.set(event, handlers);
    }

    public function unsubscribe(event:String, handler: Dynamic):Void {
        var handlers: Array<Dynamic> = subscriptions.get(event);
        if(handlers == null) {
            return;
        }
        handlers.remove(handler);
        if(handlers.length == 0) {
            subscriptions.remove(event);
        }
    }

    public function unsubscribeAll(event:String): Void {
        subscriptions.remove(event);
    }

    public function notify(eventName:String, args: Dynamic):Void {
        var handlers: Array<Dynamic> = subscriptions.get(eventName);
        if(handlers == null) {
            return;
        }
        for(handler in handlers) {
            Reflect.callMethod(null, handler, args);
        }
    }
}
