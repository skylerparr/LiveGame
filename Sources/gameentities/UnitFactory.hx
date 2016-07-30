package gameentities;
import core.BaseObject;
interface UnitFactory extends BaseObject {
    function createUnitDisplayByUnitTypeId(unitType: String): AnimatedPoseDisplay;
}
