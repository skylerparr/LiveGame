package world;
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

}
