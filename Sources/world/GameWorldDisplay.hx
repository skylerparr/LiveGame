package world;
import display.DisplayNodeContainer;
import geom.Point;
import display.DisplayNode;
import core.BaseObject;
interface GameWorldDisplay extends GameWorld {
    /**
     * get the container where all world entities displays
     * are contained
     */
    var displayContainer(get, null): DisplayNodeContainer;

    /**
     * Given a game Object the world map will return a display node associated with it.
     *
     * @param worldEntity
     * @return display associated with the game Object
     */
    function getDisplayByGameObject(gameObject: WorldEntity): DisplayNode;

    /**
     * Returns the gameobject associated by the display node
     *
     * @param displayNode
     * @return the gameobject associated with the display node
     */
    function getWorldEntityByDisplay(displayNode: DisplayNode): WorldEntity;

    /**
     * current playable area, extends passed viewport
     */
    var totalWidth(get, null): Float;

    /**
     * currently playable area, extends passed viewport
     */
    var totalHeight(get, null): Float;

}
