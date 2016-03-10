package util;
import core.BaseObject;
interface EventNotifier extends BaseObject {
    function notify(eventName: String, args: Dynamic): Void;
}
