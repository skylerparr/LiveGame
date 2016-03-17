package util;
import core.BaseObject;
interface Subscriber extends BaseObject {
    function subscribe(event: String, handler: Dynamic): Void;
    function unsubscribe(event: String, handler: Dynamic): Void;

    function unsubscribeAll(event: String): Void;
}
