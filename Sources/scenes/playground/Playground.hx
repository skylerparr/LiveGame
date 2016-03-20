package scenes.playground;
import kha.input.Mouse;
import animation.AnimationController;
import haxe.Json;
import animation.spec.TexturePackerJSONArrayFrameSpec;
import animation.Animation;
import constants.LayerNames;
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

    private var animation: Animation;
    private var image: Image;
    private var frames: TexturePackerJSONArrayFrameSpec;
    private var animationControllers: List<AnimationController>;

    public function new() {
    }

    public function init():Void {
        animationControllers = new List<AnimationController>();

        showPlayground(function(): Void {
            Mouse.get().notify(onDown, null, null, null);

        });
    }

    private function onDown(x:Int, y:Int, z:Int):Void {
        if(x == 0) {
            createWizard(y, z);
        } else {
            var controller: AnimationController = animationControllers.pop();
            while(controller != null) {
                controller.stop();
                controller = animationControllers.pop();
            }
        }
    }

    public function dispose():Void {
    }

    @:async
    private function showPlayground():Void {
        var bottomLayer: DisplayNodeContainer = layerManager.getLayerByName(LayerNames.TERRAIN);
        var middleLayer: DisplayNodeContainer = layerManager.getLayerByName(LayerNames.GAME_OBJECTS);

        var grumpyCat: BitmapNode = objectCreator.createInstance(BitmapNode);
        image = @await Assets.loadImage("grumpy_cat_nope");
        grumpyCat.imageData = image;
        grumpyCat.sx = 0;
        grumpyCat.sy = 0;
        grumpyCat.sw = image.realWidth;
        grumpyCat.sh = image.realHeight;
        bottomLayer.addChild(grumpyCat);

        image = @await Assets.loadImage("wizard");
        var jsonString = @await Assets.loadBlob("wizard_frames_json");
        frames = objectCreator.createInstance(TexturePackerJSONArrayFrameSpec,[Json.parse(cast jsonString)]);

        var topLayer:DisplayNodeContainer = uiLayerManager.getLayerByName("bottom");

        var hello: TextFieldNode = objectCreator.createInstance(TextFieldNode);
        hello.text = "hello world";
        hello.fontName = "helveticaneue_light";
        hello.fontSize = 32;
        hello.fontColor = 0xff0000ff;
        topLayer.addChild(hello);
    }

    private function createWizard(x:UInt, y:UInt):Void {
        var middleLayer: DisplayNodeContainer = layerManager.getLayerByName(LayerNames.GAME_OBJECTS);

        var wizard: BitmapNode = objectCreator.createInstance(BitmapNode);
        wizard.imageData = image;
        wizard.x = x;
        wizard.y = y;
        wizard.sx = 0;
        wizard.sy = 0;
        wizard.sw = 64;
        wizard.sh = 64;
        middleLayer.addChild(wizard);

        animation = objectCreator.createInstance(Animation);
        animation.frameTime = 50;
        animation.frames = frames.frames;
        animation.bitmap = wizard;

        var animationController: AnimationController = objectCreator.createInstance(AnimationController);
        animationController.animation = animation;
        animationController.start();

        animationControllers.add(animationController);
    }

}
