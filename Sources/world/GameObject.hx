package world;
/**
 * Is an object that can be interacted with.
 */
import constants.Poses;
interface GameObject extends WorldEntity {

    /**
     * get,sets the unit's visibility
     *
     * @param visible
     */
    var visible( get, set ): Bool;

    /**
     * gets,sets the direction that the entity should face
     */
    var lookAt(get, set): WorldPoint;

    /**
     * gets,sets the pose of the entity
     */
    var pose(get, set): Poses;

    var busy(get, set): Bool;
}
