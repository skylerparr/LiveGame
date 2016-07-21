package handler.actions;
import core.ObjectCreator;
import gameentities.UnitInteractionManager;
import world.WorldEntity;
import world.two.WorldPoint2D;
import world.GameObject;
import world.GameWorld;
import handler.input.UnitMove;
import error.Logger;
class UnitMoveAction implements StrategyAction {
    @inject
    public var logger: Logger;
    @inject
    public var gameWorld: GameWorld;
    @inject
    public var interactionManager: UnitInteractionManager;
    @inject
    public var objectCreator: ObjectCreator;

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function execute(handler:IOHandler):Void {
        var unitMove: UnitMove = cast handler;
        var unit: GameObject = cast gameWorld.getGameObjectById(unitMove.unitId + "");
        if(unit == null) {
            return;
        }
        var targetPoint: WorldPoint2D = objectCreator.createInstance(WorldPoint2D);
        targetPoint.x = unitMove.posX;
        targetPoint.z = unitMove.posZ;
        interactionManager.translateGameObjectTo(unit, targetPoint, unitMove.time);
    }
}
