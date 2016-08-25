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
        unRegisterAllEvents();
        this.interactionContainer = value;
        if(value != null) {
            registerAllEvents();
        }
        return interactionContainer;
    }

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
        gameInputTools = null;
        interactionContainer = null;
    }

    private inline function registerAllEvents(): Void {
        interactionContainer.registerPointerEvent(PointerEventType.POINTER_1_CLICK, onGameWorldPointer1Click);
        interactionContainer.registerPointerEvent(PointerEventType.POINTER_1_UP, onGameWorldPointer1Up);
        interactionContainer.registerPointerEvent(PointerEventType.POINTER_1_DOWN, onGameWorldPointer1Down);
        interactionContainer.registerPointerEvent(PointerEventType.POINTER_2_CLICK, onGameWorldPointer2Click);
        interactionContainer.registerPointerEvent(PointerEventType.POINTER_2_UP, onGameWorldPointer2Up);
        interactionContainer.registerPointerEvent(PointerEventType.POINTER_2_DOWN, onGameWorldPointer2Down);
        interactionContainer.registerPointerEvent(PointerEventType.POINTER_3_CLICK, onGameWorldPointer3Click);
        interactionContainer.registerPointerEvent(PointerEventType.POINTER_3_UP, onGameWorldPointer3Up);
        interactionContainer.registerPointerEvent(PointerEventType.POINTER_3_DOWN, onGameWorldPointer3Down);
        interactionContainer.registerPointerEvent(PointerEventType.POINTER_1_DOUBLE_CLICK, onGameWorldPointer1DoubleClick);
        interactionContainer.registerPointerEvent(PointerEventType.ZOOM, onGameWorldZoom);
        interactionContainer.registerPointerEvent(PointerEventType.POINTER_MOVE, onGameWorldPointerMove);
    }

    private inline function unRegisterAllEvents():Void {
        if(interactionContainer != null) {
            interactionContainer.unRegisterPointerEvent(PointerEventType.POINTER_1_CLICK, onGameWorldPointer1Click);
            interactionContainer.unRegisterPointerEvent(PointerEventType.POINTER_1_UP, onGameWorldPointer1Up);
            interactionContainer.unRegisterPointerEvent(PointerEventType.POINTER_1_DOWN, onGameWorldPointer1Down);
            interactionContainer.unRegisterPointerEvent(PointerEventType.POINTER_2_CLICK, onGameWorldPointer2Click);
            interactionContainer.unRegisterPointerEvent(PointerEventType.POINTER_2_UP, onGameWorldPointer2Up);
            interactionContainer.unRegisterPointerEvent(PointerEventType.POINTER_2_DOWN, onGameWorldPointer2Down);
            interactionContainer.unRegisterPointerEvent(PointerEventType.POINTER_3_CLICK, onGameWorldPointer3Click);
            interactionContainer.unRegisterPointerEvent(PointerEventType.POINTER_3_UP, onGameWorldPointer3Up);
            interactionContainer.unRegisterPointerEvent(PointerEventType.POINTER_3_DOWN, onGameWorldPointer3Down);
            interactionContainer.unRegisterPointerEvent(PointerEventType.POINTER_1_DOUBLE_CLICK, onGameWorldPointer1DoubleClick);
            interactionContainer.unRegisterPointerEvent(PointerEventType.ZOOM, onGameWorldZoom);
            interactionContainer.unRegisterPointerEvent(PointerEventType.POINTER_MOVE, onGameWorldPointerMove);
        }
    }

    private function onGameWorldPointer1Click(e:PointerEvent):Void {
        gameInputTools.currentTool.onPointerClick(e);
    }

    private function onGameWorldPointer1Up(e:PointerEvent):Void {
        gameInputTools.currentTool.onPointerUp(e);
    }

    private function onGameWorldPointer1Down(e:PointerEvent):Void {
        gameInputTools.currentTool.onPointerDown(e);
    }

    private function onGameWorldPointer2Click(e:PointerEvent):Void {
        gameInputTools.currentTool.onPointerRightClick(e);
    }

    private function onGameWorldPointer2Up(e:PointerEvent):Void {
        gameInputTools.currentTool.onPointerRightUp(e);
    }

    private function onGameWorldPointer2Down(e:PointerEvent):Void {
        gameInputTools.currentTool.onPointerRightDown(e);
    }

    private function onGameWorldPointer3Click(e:PointerEvent):Void {
        gameInputTools.currentTool.onPointerMiddleClick(e);
    }

    private function onGameWorldPointer3Up(e:PointerEvent):Void {
        gameInputTools.currentTool.onPointerMiddleUp(e);
    }

    private function onGameWorldPointer3Down(e:PointerEvent):Void {
        gameInputTools.currentTool.onPointerMiddleDown(e);
    }

    private function onGameWorldPointer1DoubleClick(e:PointerEvent):Void {
        gameInputTools.currentTool.onPointerDoubleClick(e);
    }

    private function onGameWorldZoom(e:PointerEvent):Void {
        gameInputTools.currentTool.onScroll(e);
    }

    private function onGameWorldPointerMove(e:PointerEvent):Void {
        gameInputTools.currentTool.onPointerMove(e);
    }

}
