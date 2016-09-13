package gameentities;
import vo.SpellVO;
import world.GameObject;
import world.WorldPoint;
import core.BaseObject;
interface HeroInteraction extends BaseObject {
    var hero(get, set): GameObject;
    function getCurrentLocation(): WorldPoint;
    function moveTo(worldPoint: WorldPoint): Void;
    function castSpell(targetUnit: GameObject, targetLocation: WorldPoint, spell:SpellVO): Void;
    function moveSquadTo(targetUnit: GameObject, targetLocation: WorldPoint): Void;
    function assignUnit(targetUnit: GameObject): Void;
}
