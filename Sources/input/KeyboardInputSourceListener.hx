package input;
import core.BaseObject;
interface KeyboardInputSourceListener extends BaseObject {
    function onKeyDown(keyEvent: KeyEvent): Void;
    function onKeyUp(keyEvent: KeyEvent): Void;
}
