package gameentities.fx;
import world.WorldPoint;
import core.BaseObject;
interface EffectManager extends BaseObject {
    function spawnEffect(effect: Class<SpecialEffect>, worldPoint: WorldPoint): String;
    function endEffect(key: String): Void;
}
