package world;
import geom.Point;
import display.DisplayNode;
import core.BaseObject;
interface GameWorld extends BaseObject {
    /**
     * Return a collection of the placeables on the map.
     */
    var gameObjects(get, null): List<WorldEntity>;

    /**
     * Add a placeable to the map at the provided position.
     *
     * @param worldEntity
     * @param worldPt
     */
    function addGameObject( gameObject: WorldEntity, worldPt: WorldPoint ): Void;

    /**
     * Move an existing Placeable item to a new point.
     *
     * @param item
     * @param worldPt
     */
    function moveItemTo( item: WorldEntity, worldPt: WorldPoint ): Void;

    /**
     * Remove a placeable item from the map.
     *
     * @param worldEntity
     */
    function removeGameObject( gameObject: WorldEntity ): Void;

    function removeAllObjects(): Void;

    /**
     * Given a game Object the world map will return a display node associated with it.
     *
     * @param worldEntity
     * @return display associated with the game Object
     */
    function getDisplayByGameObject(gameObject: WorldEntity): DisplayNode;

    /**
     * current playable area, extends passed viewport
     */
    var totalWidth(get, null): Float;

    /**
     * currently playable area, extends passed viewport
     */
    var totalHeight(get, null): Float;

    function getGameObjectById(id: String): WorldEntity;

    function getItemAt(worldPoint: WorldPoint): WorldEntity;

    function worldToScreen(worldPoint: WorldPoint): Point;

    function screenToWorld(point: Point): WorldPoint;
}
