package world;
import geom.Point;
import display.DisplayNode;
import core.BaseObject;
interface GameWorld extends BaseObject {
    /**
     * Return a collection of the placeables on the map.
     */
    var gameObjects(get, null): List<GameObject>;

    /**
     * Add a placeable to the map at the provided position.
     *
     * @param gameObject
     * @param worldPt
     */
    function addGameObject( gameObject: GameObject, worldPt: WorldPoint ): Void;

    /**
     * Move an existing Placeable item to a new point.
     *
     * @param item
     * @param worldPt
     */
    function moveItemTo( item: GameObject, worldPt: WorldPoint ): Void;

    /**
     * Remove a placeable item from the map.
     *
     * @param gameObject
     */
    function removeGameObject( gameObject: GameObject ): Void;

    function removeAllObjects(): Void;

    /**
     * Given a game Object the world map will return a display node associated with it.
     *
     * @param gameObject
     * @return display associated with the game Object
     */
    function getDisplayByGameObject(gameObject: GameObject): DisplayNode;

    /**
     * currently playable area, extends passed viewport
     */
    var totalWidth(get, null): Float;

    /**
     * currently playable area, extends passed viewport
     */
    var totalHeight(get, null): Float;

    function getGameObjectById(id: String): GameObject;

    function getItemAt(worldPoint: WorldPoint): GameObject;

    function worldToScreen(worldPoint: WorldPoint): Point;

    function screenToWorld(point: Point): WorldPoint;
}
