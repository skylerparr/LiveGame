package world;
import core.BaseObject;
import geom.Rectangle;
import display.DisplayNode;
interface ViewPort extends BaseObject {
    /**
     *  Returns the height of the viewport measured in world coordinates.  "Height" refers to the
     *  extent along the y-axis.
     */
    var height(get, null): Float;

    /**
     * Returns the horizontal extent along the x-axis as measured in world coordinates.
     */
    var width(get, null): Float;

    /**
     *  The x-position of the viewport in world coordinates. Measured from the upper left-hand corner of the viewport.
     */
    var x(get, set): Float;

    /**
     *  The y-position of the viewport in world coordinates. Measured from the upper left-hand corner of the viewport.
     */
    var y(get, set): Float;

    /**
     *  The z-position of the viewport in world coordinates. Measured from the upper left-hand corner of the viewport.
     */
    var z(get, set): Float;

    var scale(get, set): Float;

    /**
     * Returns the dimension of viewPort.
     */
    var dimension(get, null): Rectangle;

    /**
     *  Return whether or not this object can be seen in the region displayed in the viewport.
     */
    function isInViewableRegion( value: DisplayNode ): Bool;

    function subscribeToTranslate(listener: Void->Void): Void;
    function unsubscribeToTranslate(listener: Void->Void): Void;

    function subscribeToResize(listener: Void->Void): Void;
    function unsubscribeToResize(listener: Void->Void): Void;
}
