package core;
import minject.Injector;
class ObjectFactory implements ObjectCreator {

    public static var injector(default, default): Injector;

    public function new() {
    }

    public static function createObject(clazz: Class<Dynamic>, ?constructorArgs: Array<Dynamic>): Dynamic {
        var retVal: Dynamic = null;
        try {
             retVal = injector.getInstance(clazz);
        } catch(e: Dynamic) {
            retVal = Type.createInstance(clazz, constructorArgs);
            injector.injectInto(retVal);
        }
        if(Std.is(retVal, BaseObject)) {
            retVal.init();
        }
        return retVal;
    }

    public static function inject(object: Dynamic): Void {
        injector.injectInto(object);
    }

    public function createInstance(clazz: Class<Dynamic>, ?constructorArgs: Array<Dynamic>): Dynamic {
        return ObjectFactory.createObject(clazz, constructorArgs);
    }

}
