package util;
import display.DisplayNodeContainer;
import constants.LayerNames;
import core.ObjectCreator;
import display.TextFieldNode;
import constants.EventNames;
import display.LayerManager;
import core.BaseObject;
class Fps implements BaseObject{

    @inject
    public var objectCreator: ObjectCreator;

    @inject
    public var layerManager: LayerManager;

    @inject
    public var subscriber: Subscriber;

    private var textFieldBack: TextFieldNode;
    private var textField: TextFieldNode;
    private var frameCount: UInt;
    private var previousTime: UInt;

    public function new() {
    }

    public function init():Void {
        enable();
    }

    public function dispose():Void {
        subscriber.unsubscribe(EventNames.ENTER_GAME_LOOP, onGameLoop);
    }

    public function enable(): Void {
        subscriber.subscribe(EventNames.ENTER_GAME_LOOP, onGameLoop);
        drawFps();
    }

    public function disable(): Void {
        subscriber.unsubscribe(EventNames.ENTER_GAME_LOOP, onGameLoop);

        var debugLayer: DisplayNodeContainer = layerManager.getLayerByName(LayerNames.DEBUG);
        debugLayer.removeChild(textField);
    }

    private inline function drawFps():Void {
        var debugLayer: DisplayNodeContainer = layerManager.getLayerByName(LayerNames.DEBUG);

        textFieldBack = objectCreator.createInstance(TextFieldNode);
        textFieldBack.fontSize = 14;
        textFieldBack.fontColor = 0xffffffff;
        textFieldBack.fontName = "helveticaneue_light";
        textFieldBack.x = 1;
        textFieldBack.y = 1;
        debugLayer.addChild(textFieldBack);

        textField = objectCreator.createInstance(TextFieldNode);
        textField.fontSize = 14;
        textField.fontColor = 0xff000000;
        textField.fontName = "helveticaneue_light";
        debugLayer.addChild(textField);

        frameCount = 0;
        previousTime = Timer.now();
    }

    private function onGameLoop():Void {
        frameCount++;
        var now: UInt = Timer.now();
        if(now - previousTime < 1000) {
            return;
        }

        textFieldBack.text = textField.text = frameCount + " fps";

        previousTime = Timer.now();
        frameCount = 1;
    }
}
