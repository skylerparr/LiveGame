package ui;
import geom.Rectangle;
import core.BaseObject;
interface UIManager extends BaseObject {
    /**
     * registered area on screen and returns interactive area
     * key to be fetch or removed
     */
    function registerInteractiveArea(rect: Rectangle): UInt;

    /**
     * Accepts interactive area key and unregisters area
     * to be interactive with
     */
    function unregisterInteractiveArea(key: UInt): Void;

    /**
     * returns area of interaction from key
     * returns null if key is not matched
     */
    function getInteractiveArea(key: UInt): Rectangle;

    /**
     * Return an array of interactable areas on screen
     */
    function getAllInteractiveAreas(): Array<Rectangle>;
}
