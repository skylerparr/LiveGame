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
        #if !test
        kha.input.Keyboard.get(0).remove(onKeyDown, onKeyUp, onKeyPress);
        #end
    }

    public function onKeyDown(key: #if test input.kha.MockKeyboardKey #else kha.input.KeyCode #end):Void {
        var k: Int = cast(key, Int);
        keyEvent.key = k;
        gameInputTools.keyboardTool.onKeyDown(keyEvent);
    }

    public function onKeyUp(key: #if test input.kha.MockKeyboardKey #else kha.input.KeyCode #end):Void {
        var k: Int = cast(key, Int);
        keyEvent.key = k;
        gameInputTools.keyboardTool.onKeyUp(keyEvent);
    }

    @IgnoreCover
    public function onKeyPress(char: String):Void {
        //no use for this at this time
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
