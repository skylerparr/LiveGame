package gameentities;
import core.BaseObject;
import world.GameObject;
interface UnitFactory extends BaseObject {
    function createUnitDisplayByUnitTypeId(unitType: String): AnimatedDisplay;
}
