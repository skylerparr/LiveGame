package gameentities;
import gameentities.fx.SpecialEffect;
import gameentities.fx.EffectManager;
import vo.SpellVO;
import world.WorldPoint;
import animation.tween.TweenTarget;
import constants.Poses;
import animation.tween.Tween;
import world.two.WorldPoint2D;
import world.GameObject;
import core.ObjectCreator;
import world.GameWorldDisplay;
class BattleUnitInteractionManager implements UnitInteractionManager {

    @inject
    public var gameWorld: GameWorldDisplay;
    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var effectManager: EffectManager;

    public var objectTweenMap: Map<GameObject, Tween>;

    public var specialEffectMap: Map<GameObject, String>;

    public function new() {
    }

    public function init():Void {
        objectTweenMap = new Map<GameObject, Tween>();
        specialEffectMap = new Map<GameObject, String>();
    }

    public function dispose():Void {
        gameWorld = null;
        objectCreator = null;
        objectTweenMap = null;
        specialEffectMap = null;
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
        if(gameObject != null) {
            gameObject.pose = Poses.SPECIAL;
            gameObject.busy = true;
            var fxKey: String = effectManager.spawnEffect(getSpawnFX(), worldPoint);
            specialEffectMap.set(gameObject, fxKey);
        }
    }

    public function spellCasted(spell:SpellVO, gameObject:GameObject, worldPoint:WorldPoint, targetGameObject:GameObject):Void {
        if(gameObject != null) {
            gameObject.pose = Poses.IDLE;
            gameObject.busy = false;
            var fxKey: String = specialEffectMap.get(gameObject);
            effectManager.endEffect(fxKey);
            specialEffectMap.remove(gameObject);
        }
    }

    private inline function getSpawnFX(): Class<SpecialEffect> {
        #if test
        return SpecialEffect;
        #else
        return gameentities.fx.UnitSpawnFX;
        #end
    }

}
