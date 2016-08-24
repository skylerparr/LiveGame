package input;
import display.DisplayNodeContainer;
class BattleGameWorldInteractionManager implements GameWorldInteractionManager {
    @inject
    public var gameInputTools: GameInputTools;

    @:isVar
    public var interactionContainer(get, set): DisplayNodeContainer;

    function get_interactionContainer():DisplayNodeContainer {
        return interactionContainer;
    }

    function set_interactionContainer(value:DisplayNodeContainer) {
        value.registerPointerEvent(PointerEventType.POINTER_1_CLICK, onGameWorldClicked);
        return this.interactionContainer = value;
    }

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    private function onGameWorldClicked(e:PointerEvent):Void {
        trace("clicked the game world");
        trace('${e.screenX}, ${e.screenY}');
    }
}
