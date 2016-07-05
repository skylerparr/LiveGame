package handler.actions;
import animation.tween.Tween;
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
        var unitMove: UnitMove = cast handler;
        var unit: GameObject = cast gameWorld.getGameObjectById(unitMove.unitId + "");

        var worldPoint: WorldPoint = new WorldPoint2D(unit.x, unit.z);
        unit.lookAt = new WorldPoint2D(unitMove.posX, unitMove.posZ);

        var tween: Tween = objectCreator.createInstance(Tween);
        tween.to(worldPoint, unitMove.time, {x: unitMove.posX, z: unitMove.posZ})
        .onUpdate(function(tween: Tween): Void {
            unit.pose = Poses.RUN;
            gameWorld.moveItemTo(unit, worldPoint);
        }).onComplete(function(tween: Tween): Void {
            unit.pose = Poses.IDLE;
        });
    }
}
