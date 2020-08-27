package world;
import core.BaseObject;
interface WorldEntity extends BaseObject {
    /**
     * unique identifier of this piece of content
     *
     */
    var id(get, null): Int;

    /**
     *  Get the footPrint of Placeable Item;
     */
    var footprint(get, null): Footprint;

    /**
     *  Get the bounding Box of Placeable item;
     */
    var bounds(get, null): Bounds;

    /**
     * The unit type that belongs to the same category
     */
    var type(get, null): String;

    /**
     * The unit category like building, unit, tree.
     */
    var category(get, null): String;

    /**
     * The x-position in the world coordinate system.
     */
    var x(get, set): Float;

    /**
     * The y-position in the world coordinate system.
     */
    var y(get, set): Float;

    /**
     * The z-coordinate in the world coordinate system.
     */
    var z(get, set): Float;

    /**
     * Return the world point to the user. This is non-mutable in that it will not update this
     * object's world coordinates.
     */
    var worldPoint(get, null): WorldPoint;

}
