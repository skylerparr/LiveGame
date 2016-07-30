package gameentities.fx;
import world.WorldPoint;
import core.BaseObject;
interface SpecialEffect extends BaseObject {
    function begin(worldPoint: WorldPoint): Void;
    function end(onComplete: SpecialEffect->Void): Void;
}
