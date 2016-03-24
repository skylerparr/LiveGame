package scenes.playground;
import gameentities.WizardGameObject;
import world.two.WorldPoint2D;
import world.WorldPoint;
import geom.Point;
import world.GameWorld;
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

    @inject("world")
    public var layerManager: LayerManager;
    @inject("ui")
    public var uiLayerManager: LayerManager;
    @inject
    public var gameWorld: GameWorld;

    private var lastWizard: WizardGameObject;

    public function new() {
    }

    public function init():Void {
        showPlayground(function(): Void {
            Mouse.get().notify(onDown, null, null, null);

        });
    }

    private function onDown(button:Int, x:Int, y:Int):Void {
        if(button == 0) {
            createWizard(x, y);
        } else {
            moveLastWizard(x, y);
        }
    }

    public function dispose():Void {
    }

    @:async
    private function showPlayground():Void {
        var bottomLayer: DisplayNodeContainer = layerManager.getLayerByName(LayerNames.TERRAIN);
        var middleLayer: DisplayNodeContainer = layerManager.getLayerByName(LayerNames.GAME_OBJECTS);

        var grumpyCat: BitmapNode = objectCreator.createInstance(BitmapNode);
        var image = @await Assets.loadImage("grumpy_cat_nope");
        grumpyCat.imageData = image;
        grumpyCat.sx = 0;
        grumpyCat.sy = 0;
        grumpyCat.sw = image.realWidth;
        grumpyCat.sh = image.realHeight;
        bottomLayer.addChild(grumpyCat);

        var topLayer:DisplayNodeContainer = uiLayerManager.getLayerByName("bottom");

        var hello: TextFieldNode = objectCreator.createInstance(TextFieldNode);
        hello.text = "hello world";
        hello.fontName = "helveticaneue_light";
        hello.fontSize = 32;
        hello.fontColor = 0xff0000ff;
        topLayer.addChild(hello);
    }

    private inline function createWizard(x:Float, y:Float):Void {
        var worldPoint: WorldPoint = gameWorld.screenToWorld(new Point(x, y));
        lastWizard = objectCreator.createInstance(WizardGameObject);
        gameWorld.addGameObject(lastWizard, worldPoint);
    }

    private inline function moveLastWizard(x:Float, y:Float):Void {
        var worldPoint: WorldPoint = gameWorld.screenToWorld(new Point(x, y));
        gameWorld.moveItemTo(lastWizard, worldPoint);
    }

}
