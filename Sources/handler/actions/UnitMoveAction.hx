package handler.actions;
import constants.Poses;
import util.Subscriber;
import world.WorldEntity;
import world.WorldPoint;
import world.two.WorldPoint2D;
import world.GameObject;
import core.ObjectCreator;
import world.GameWorld;
import handler.input.UnitMove;
import error.Logger;
class UnitMoveAction implements StrategyAction {
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
        var unitCreated: UnitMove = cast handler;
        var unit: WorldEntity = gameWorld.getGameObjectById(unitCreated.unitId + "");

        var worldPoint: WorldPoint = new WorldPoint2D(unitCreated.posX, unitCreated.posY);
        gameWorld.moveItemTo(unit, worldPoint);
    }
}
