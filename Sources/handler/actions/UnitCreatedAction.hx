package handler.actions;
import handler.input.UnitCreated;
import world.GameWorld;
import core.ObjectCreator;
import gameentities.NecroDisplay;
import gameentities.NecroGameObject;
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
        createWizard(unitCreated.unitId, unitCreated.posX, unitCreated.posY);
    }

    private inline function createWizard(id: Int, x:Float, y:Float):Void {
        var worldPoint: WorldPoint = gameWorld.screenToWorld(new Point(x, y));
        var lastUnit: NecroGameObject = objectCreator.createInstance(NecroGameObject);
        lastUnit.id = id + "";
        gameWorld.addGameObject(lastUnit, worldPoint);

        var unitDisplay: NecroDisplay = cast gameWorld.getDisplayByGameObject(lastUnit);
        lastUnit.display = unitDisplay;
    }

}
