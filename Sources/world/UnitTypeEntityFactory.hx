package world;
import gameentities.UnitFactory;
import core.ObjectCreator;
import display.DisplayNode;
import units.EntityFactory;
class UnitTypeEntityFactory implements EntityFactory {
    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var unitFactory: UnitFactory;

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function createViewForEntity(worldEntity:WorldEntity):DisplayNode {
        return unitFactory.createUnitDisplayByUnitTypeId(worldEntity.type);
    }

    public function disposeViewForEntity(worldEntity:WorldEntity, display:DisplayNode):Void {
        objectCreator.disposeInstance(display);
    }
}
