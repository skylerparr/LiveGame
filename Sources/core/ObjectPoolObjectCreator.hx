package core;
import haxe.ds.ObjectMap;
import minject.Injector;
class ObjectPoolObjectCreator  implements ObjectCreator {

    public static var injector: Injector;

    public var pool: ObjectMap<Dynamic, List<Dynamic>>;

    public function new() {
        pool = new ObjectMap<Dynamic, List<Dynamic>>();
    }

    public function createInstance(clazz:Class<Dynamic>, ?constructorArgs:Array<Dynamic>):Dynamic {
        if(constructorArgs == null) {
            constructorArgs = [];
        }
        var retVal = pullFromPool(clazz, constructorArgs);

        if(Std.is(retVal, BaseObject)) {
            retVal.init();
        }

        return retVal;
    }

    public function disposeInstance(object:Dynamic): Void {
        if(Std.is(object, BaseObject)) {
            object.dispose();
        }
        addToPool(object);
        injector.attendedToInjectees.remove(object);
    }

    private inline function pullFromPool(clazz:Class<Dynamic>, ?constructorArgs:Array<Dynamic>):Dynamic {
        var retVal: Dynamic = null;
        clazz = injector.getMapping(clazz).request;
//        trace(injector.getMapping(clazz).toString());
//        trace("getting from pool " + clazz);
        if(pool.exists(clazz)) {
            var items: List<Dynamic> = pool.get(clazz);
            if(items.length > 0) {
                retVal = items.pop();
            }
        }
        if(retVal == null) {
            try {
                retVal = injector.getInstance(clazz);
            } catch(e: Dynamic) {
                retVal = Type.createInstance(clazz, constructorArgs);
            }
        }
        injector.injectInto(retVal);
        return retVal;
    }

    private inline function addToPool(object:Dynamic):Void {
        var type: Class<Dynamic> = Type.getClass(object);
        if(!pool.exists(type)) {
            pool.set(type, new List<Dynamic>());
        }
//        trace("adding to pool " + type);
        pool.get(type).add(object);
//        trace("new amount is : " + pool.get(type).length);
    }
}
