package handler.actions;
import world.GameObject;
import handler.input.UnitCreated;
import world.GameWorld;
import core.ObjectCreator;
#if !test
import gameentities.NecroDisplay;
import gameentities.NecroGameObject;
#end
import geom.Point;
import world.WorldPoint;
import error.Logger;
class UnitCreatedAction implements StrategyAction {

    @inject
    public var logger: Logger;
    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var gameWorld: GameWorld;

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function execute(handler:IOHandler):Void {
        logger.logDebug("unit created");
        var unitCreated: UnitCreated = cast handler;
        var unit: GameObject = createUnit(unitCreated.unitId, unitCreated.unitType);

        var worldPoint: WorldPoint = gameWorld.screenToWorld(new Point(unitCreated.posX, unitCreated.posY));
        gameWorld.addGameObject(unit, worldPoint);
    }

    public function createUnit(unitId: Int, unitType: Int): GameObject {
        #if !test
        var unit: NecroGameObject = objectCreator.createInstance(NecroGameObject);
        unit.id = unitId + "";

        var unitDisplay: NecroDisplay = cast gameWorld.getDisplayByGameObject(unit);
        unit.display = unitDisplay;

        return unit;
        #else
        return null;
        #end
    }

}
