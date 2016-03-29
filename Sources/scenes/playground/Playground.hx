package scenes.playground;
import constants.Poses;
import util.MathUtil;
import gameentities.NecroDisplay;
import gameentities.NecroGameObject;
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

    private var lastUnit: NecroGameObject;
    private var rise: Float = 0;
    private var run: Float = 0;
    private var targetLocation: WorldPoint = new WorldPoint2D();

    public function new() {
    }

    public function init():Void {
        showPlayground(function(): Void {
            Mouse.get().notify(onDown, null, null, null);
        });

        subscriber.subscribe(EventNames.ENTER_GAME_LOOP, onGameLoop);
    }

    private function onGameLoop():Void {
        if(lastUnit == null) {
            return;
        }

        if(between(invert(run), invert(rise))) {
            moveLastWizard(targetLocation.x, targetLocation.z);
            lastUnit.setPose(Poses.IDLE);
            return;
        }

        moveLastWizard(lastUnit.x + run, lastUnit.z + rise);
    }

    private inline function invert(value: Float): Float {
        if(value < 0) {
            value = -value;
        }
        return value;
    }

    private inline function between(_run: Float, _rise: Float):Bool {
        return (lastUnit.x >= targetLocation.x - _run) &&
            (lastUnit.x <= targetLocation.x + _run) &&
            (lastUnit.z >= targetLocation.z - _rise) &&
            (lastUnit.z <= targetLocation.z + _rise);

    }

    private function onDown(button:Int, x:Int, y:Int):Void {
        if(button == 0) {
            if(lastUnit == null) {
                createWizard(x, y);
            }
        } else {
            if(lastUnit == null) {
                return;
            }
            targetLocation = gameWorld.screenToWorld(new Point(x, y));

            lastUnit.lookAt = targetLocation;

            var velocity: Float = 40 * 1 / 60;
            var angle: Float = MathUtil.getDirectionInDegrees(lastUnit.worldPoint, targetLocation) - 90;

            run = Math.cos(MathUtil.degreesToRadians(angle)) * velocity;
            rise = Math.sin(MathUtil.degreesToRadians(angle)) * velocity;

            lastUnit.setPose(Poses.RUN);
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
        lastUnit = objectCreator.createInstance(NecroGameObject);
        gameWorld.addGameObject(lastUnit, worldPoint);

        var unitDisplay: NecroDisplay = cast gameWorld.getDisplayByGameObject(lastUnit);
        lastUnit.display = unitDisplay;
    }

    private inline function moveLastWizard(x:Float, y:Float):Void {
        var worldPoint: WorldPoint = new WorldPoint2D(x, y);
        gameWorld.moveItemTo(lastUnit, worldPoint);
    }

}
