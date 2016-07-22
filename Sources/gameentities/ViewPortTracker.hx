package gameentities;
import core.BaseObject;
import world.GameObject;
interface ViewPortTracker extends BaseObject {
    function trackToGameObject(gameObject: GameObject): Void;
    function untrackFromGameObject(): Void;
}
