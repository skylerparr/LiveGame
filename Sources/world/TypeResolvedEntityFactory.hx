package world;
import core.ObjectCreator;
import display.DisplayNode;
import units.EntityFactory;
import haxe.ds.ObjectMap;
class TypeResolvedEntityFactory implements EntityFactory {

    @inject
    public var objectCreator: ObjectCreator;

    public var entityMap: ObjectMap<Dynamic, Dynamic>;

    public function new() {
    }

    public function init():Void {
        entityMap = new ObjectMap<Dynamic, Dynamic>();
    }

    public function dispose():Void {
        objectCreator = null;
        entityMap = null;
    }

    public function mapTypeToType(typeA: Class<Dynamic>, typeB: Class<Dynamic>): Void {
        entityMap.set(typeA, typeB);
    }

    public function createViewForEntity(worldEntity:WorldEntity):DisplayNode {
        var type: Class<Dynamic> = Type.getClass(worldEntity);
        var mappedType: Class<Dynamic> = entityMap.get(type);
        var retVal: Dynamic = objectCreator.createInstance(mappedType);
        return retVal;
    }

    public function disposeViewForEntity(worldEntity:WorldEntity, display:DisplayNode):Void {
        objectCreator.disposeInstance(display);
    }
}
