package input.kha;
import core.ObjectCreator;
import core.BaseObject;
class KhaKeyboardInputSourceListener implements BaseObject {
    
    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var gameInputTools: GameInputTools;

    private var keyEvent: KeyEvent;

    public function new() {
    }

    public function init():Void {
        keyEvent = objectCreator.createInstance(KeyEvent);
        initKeyboardNotifications();
    }

    public function dispose():Void {
        objectCreator.disposeInstance(keyEvent);
        objectCreator = null;
        gameInputTools = null;
        keyEvent = null;
    }

    public function onKeyDown(key: #if test input.kha.MockKeyboardKey #else kha.input.KeyCode #end):Void {
        keyEvent.key = cast(key, Int);
        gameInputTools.keyboardTool.onKeyDown(keyEvent);
    }

    public function onKeyUp(key: #if test input.kha.MockKeyboardKey #else kha.input.KeyCode #end):Void {
        keyEvent.key = cast(key, Int);
        gameInputTools.keyboardTool.onKeyUp(keyEvent);
    }

    public function onKeyPress(char: String):Void {
    }

    #if test
    public function initKeyboardNotifications():Void {

    }
    #else
    public function initKeyboardNotifications():Void {
        kha.input.Keyboard.get(0).notify(onKeyDown, onKeyUp, onKeyPress);
    }
    #end
}
