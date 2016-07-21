package gameentities;
import world.GameObject;
import world.WorldPoint;
import core.BaseObject;
interface HeroInteraction extends BaseObject {
    var hero(get, set): GameObject;
    function getCurrentLocation(): WorldPoint;
    function moveTo(worldPoint: WorldPoint): Void;

}
