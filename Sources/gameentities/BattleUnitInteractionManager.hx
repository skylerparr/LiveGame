package gameentities;
import vo.SpellVO;
import vo.SpellVO;
import world.WorldPoint;
import animation.tween.TweenTarget;
import constants.Poses;
import animation.tween.Tween;
import world.two.WorldPoint2D;
import world.GameObject;
import core.ObjectCreator;
import world.GameWorld;
class BattleUnitInteractionManager implements UnitInteractionManager {
    
    @inject
    public var gameWorld: GameWorld;
    @inject
    public var objectCreator: ObjectCreator;

    public var objectTweenMap: Map<GameObject, Tween>;

    public function new() {
    }

    public function init():Void {
        objectTweenMap = new Map<GameObject, Tween>();
    }

    public function dispose():Void {
        gameWorld = null;
        objectCreator = null;
        objectTweenMap = null;
    }

    public function translateGameObjectTo(gameObject:GameObject, targetPoint:WorldPoint, time:UInt):Void {
        killOldTween(gameObject);
        tweenUnit(gameObject, time, targetPoint);
    }

    private inline function tweenUnit(unit: GameObject, time: UInt, endingPoint: WorldPoint): Void {
        var startingPoint: WorldPoint = getWorldPoint(unit.x, unit.z);
        var lookAtPoint: WorldPoint = getWorldPoint(endingPoint.x, endingPoint.z);
        unit.lookAt = lookAtPoint;

        var tween: Tween = objectCreator.createInstance(Tween);
        tween.to(startingPoint, time, {x: endingPoint.x, z: endingPoint.z})
            .onUpdate(function(t: Tween): Void {
                unit.pose = Poses.RUN;
                gameWorld.moveItemTo(unit, startingPoint);
            })
            .onComplete(function(t: Tween): Void {
                if(!unit.busy) {
                    unit.pose = Poses.IDLE;
                }
                killOldTween(unit);
                objectCreator.disposeInstance(startingPoint);
                objectCreator.disposeInstance(lookAtPoint);
                objectCreator.disposeInstance(endingPoint);
            });
        objectTweenMap.set(unit, tween);
    }

    private inline function killOldTween(unit: GameObject): Void {
        if(objectTweenMap.exists(unit)) {
            var tween: Tween = objectTweenMap.get(unit);
            objectCreator.disposeInstance(tween);
            objectTweenMap.remove(unit);
        }
    }

    private inline function getWorldPoint(x:Float, z:Float):WorldPoint {
        var retVal: WorldPoint = objectCreator.createInstance(WorldPoint2D);
        retVal.x = x;
        retVal.z = z;
        return retVal;
    }

    public function startCastingSpell(spell:SpellVO, gameObject:GameObject, worldPoint:WorldPoint):Void {
        gameObject.pose = Poses.SPECIAL;
        gameObject.busy = true;
    }

    public function spellCasted(spell:SpellVO, gameObject:GameObject, worldPoint:WorldPoint, targetGameObject:GameObject):Void {
        gameObject.pose = Poses.IDLE;
        gameObject.busy = false;
    }

}
