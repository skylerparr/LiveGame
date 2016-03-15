package scenes.playground;
import constants.EventNames;
import util.Subscriber;
import util.EventNotifier;
import haxe.Json;
import animation.spec.TexturePackerJSONArrayFrameSpec;
import animation.Animation;
import constants.LayerNames;
import kha.Color;
import display.TextFieldNode;
import kha.Image;
import kha.Assets;
import display.DisplayNodeContainer;
import display.BitmapNode;
import display.DisplayNode;
import core.BaseObject;
import display.LayerManager;
import core.ObjectCreator;
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class Playground implements BaseObject {
    
    @inject
    public var objectCreator: ObjectCreator;

    @inject("gameWorld")
    public var layerManager: LayerManager;
    @inject
    public var uiLayerManager: LayerManager;

    @inject
    public var subscriber: Subscriber;

    private var animation: Animation;

    public function new() {
    }

    public function init():Void {
        showPlayground(function(): Void {

        });
    }

    public function dispose():Void {
    }

    @:async
    private function showPlayground():Void {
        var bottomLayer: DisplayNodeContainer = layerManager.getLayerByName(LayerNames.TERRAIN);
        var middleLayer: DisplayNodeContainer = layerManager.getLayerByName(LayerNames.GAME_OBJECTS);

        var grumpyCat: BitmapNode = objectCreator.createInstance(BitmapNode);
        var image: Image = @await Assets.loadImage("grumpy_cat_nope");
        grumpyCat.imageData = image;
        grumpyCat.sx = 0;
        grumpyCat.sy = 0;
        grumpyCat.sw = image.realWidth;
        grumpyCat.sh = image.realHeight;
        bottomLayer.addChild(grumpyCat);

        var wizard: BitmapNode = objectCreator.createInstance(BitmapNode);
        image = @await Assets.loadImage("wizard");
        wizard.imageData = image;
        wizard.sx = 0;
        wizard.sy = 0;
        wizard.sw = 64;
        wizard.sh = 64;
        middleLayer.addChild(wizard);

        var jsonString = @await Assets.loadBlob("wizard_frames_json");
        var frames: TexturePackerJSONArrayFrameSpec = objectCreator.createInstance(TexturePackerJSONArrayFrameSpec,[Json.parse(cast jsonString)]);

        animation = objectCreator.createInstance(Animation);
        animation.frames = frames.frames;
        animation.bitmap = wizard;

        subscriber.subscribe(EventNames.ENTER_GAME_LOOP, onEnterGameLoop);

        var topLayer:DisplayNodeContainer = uiLayerManager.getLayerByName("bottom");

        var hello: TextFieldNode = objectCreator.createInstance(TextFieldNode);
        hello.text = "hello world";
        hello.fontName = "helveticaneue_light";
        hello.fontSize = 32;
        hello.fontColor = 0xff0000ff;
        topLayer.addChild(hello);
    }

    private function onEnterGameLoop():Void {
        animation.nextFrame();
    }
}
