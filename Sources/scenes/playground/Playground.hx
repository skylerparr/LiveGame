package scenes.playground;
import geom.Point;
import world.two.WorldPoint2D;
import constants.EventNames;
import util.Subscriber;
import gameentities.WizardGameObject;
import world.WorldPoint;
import world.GameWorld;
import kha.input.Mouse;
import haxe.Json;
import constants.LayerNames;
import display.TextFieldNode;
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
    @inject
    public var subscriber: Subscriber;

    private var lastWizard: WizardGameObject;
    private var xPos: Float = 0;
    private var yPos: Float = 0;
    private var currentXPos: Int = 0;
    private var currentYPos: Int = 0;
    private var wizardMoving: Bool = false;

    public function new() {
    }

    public function init():Void {
        showPlayground(function(): Void {
            Mouse.get().notify(onDown, null, null, null);
        });

        subscriber.subscribe(EventNames.ENTER_GAME_LOOP, onGameLoop);
    }

    private function onGameLoop():Void {
        if(!wizardMoving) {
            return;
        }
        if(xPos > currentXPos) {
            currentXPos++;
            if(currentXPos >= xPos) {
                currentXPos = Std.int(xPos);
            }
        } else {
            currentXPos--;
            if(currentXPos <= xPos) {
                currentXPos = Std.int(xPos);
            }
        }
        if(yPos > currentYPos) {
            currentYPos++;
            if(currentYPos >= yPos) {
                currentYPos = Std.int(yPos);
            }
        } else {
            currentYPos--;
            if(currentYPos <= yPos) {
                currentYPos = Std.int(yPos);
            }
        }

        moveLastWizard(currentXPos, currentYPos);

        if(currentXPos == xPos && currentYPos == yPos) {
            wizardMoving = false;
        }

    }

    private function onDown(button:Int, x:Int, y:Int):Void {
        if(button == 0) {
            if(lastWizard == null) {
                createWizard(x, y);
            }
        } else {
            xPos = x;
            yPos = y;

            var point: Point = gameWorld.worldToScreen(new WorldPoint2D(lastWizard.x, lastWizard.z));
            currentXPos = Std.int(point.x);
            currentYPos = Std.int(point.y);

            wizardMoving = true;
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
