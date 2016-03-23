package core;
import minject.Injector;
class ObjectFactory implements ObjectCreator {

    public static var injector: Injector;

    public function new() {
    }

    public function createInstance(clazz:Class<Dynamic>, ?constructorArgs:Array<Dynamic>):Dynamic {
        if(constructorArgs == null) {
            constructorArgs = [];
        }
        var retVal = null;
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

    public function disposeInstance(object:Dynamic): Void {
        if(Std.is(object, BaseObject)) {
            object.dispose();
        }
    }

}
