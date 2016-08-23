package input;
import core.BaseObject;
interface PointingInputSourceListener extends BaseObject {
    /**
     *  Occurs when the user activates the pointer selection.
     */
    function onPointerDown( e: PointerEvent ): Void;

    /**
     * Occurs when the pointer moves to a new location.
     */
    function onPointerMove( e: PointerEvent ): Void;

    /**
     * Occurs when the user deactivates the pointer selection.
     */
    function onPointerUp( e: PointerEvent ): Void;

    /**
     *  Occurs after a pointer down/pointer up sequence on the same target.
     */
    function onPointerClick( e: PointerEvent ): Void;

    function onPointerRightDown( e: PointerEvent ): Void;

    function onPointerRightUp( e: PointerEvent ): Void;

    function onPointerRightClick( e: PointerEvent ): Void;

    function onPointerDoubleClick(e: PointerEvent): Void;

    function onScroll(e: PointerEvent): Void;

    function onPointerMiddleDown(e: PointerEvent): Void;

    function onPointerMiddleUp(e: PointerEvent): Void;

    function onPointerMiddleClick( e: PointerEvent ): Void;
}
