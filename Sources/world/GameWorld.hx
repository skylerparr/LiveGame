package world;
import geom.Point;
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

  /**
   * Removes all game objects in the scene
   */
  function removeAllObjects(): Void;

  function getGameObjectById(id: Int): WorldEntity;

  function getItemAt(worldPoint: WorldPoint): WorldEntity;
}
