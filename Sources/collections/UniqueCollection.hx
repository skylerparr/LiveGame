package collections;
import haxe.ds.ObjectMap;

class UniqueCollection <T> {

    private var map: ObjectMap<Dynamic, Dynamic>;
    private var orderEnforcer: List<T>;

    public var length(get, null): UInt;

    public function get_length(): UInt {
        return orderEnforcer.length;
    }

    public function new() {
        map = new ObjectMap<Dynamic, Dynamic>();
        orderEnforcer = new List<T>();
    }

    public inline function add(item: T): Void {
        if(!map.exists(item)) {
            map.set(item, item);
            orderEnforcer.add(item);
        }
    }

    public inline function remove(item: T): Void {
        map.remove(item);
        orderEnforcer.remove(item);
    }

    public inline function clear(): Void {
        for(item in orderEnforcer) {
            map.remove(item);
        }
        orderEnforcer.clear();
    }

    public inline function iterator():Iterator<T> {
        return orderEnforcer.iterator();
    }

    public function asList(): List<T> {
        return orderEnforcer;
    }
}
