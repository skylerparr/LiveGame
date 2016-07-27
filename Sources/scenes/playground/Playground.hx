package scenes.playground;
import vo.MutableUnitVO;
import world.GameObject;
import world.WorldPoint;
import geom.Point;
import motion.easing.Bounce;
import motion.easing.Sine;
import animation.tween.Tween;
import motion.Actuate;
import vo.UnitVO;
import vo.PlayerVO;
import service.PlayerService;
import handler.output.UnitMoveTo;
import handler.output.PlayerConnect;
import handler.StreamHandler;
import input.kha.KhaKeyboardInputSourceListener;
import constants.Poses;
import gameentities.NecroGameObject;
import world.two.WorldPoint2D;
import constants.EventNames;
import util.Subscriber;
import world.WorldPoint;
import world.GameWorld;
import kha.input.Mouse;
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
    @inject
    public var streamHandler: StreamHandler;
    @inject
    public var playerService: PlayerService;

    private var lastUnit: NecroGameObject;
    private var rise: Float = 0;
    private var run: Float = 0;
    private var targetLocation: WorldPoint = new WorldPoint2D();
    private var playerConnected: Bool = false;
    private var currentPlayer: PlayerVO;
    private var unit: GameObject;

    public function new() {
    }

    public function init():Void {
        showPlayground(function(): Void {
            Mouse.get().notify(onDown, null, null, null);
        });

        playerService.getCurrentPlayer(function(p: PlayerVO): Void {
            currentPlayer = p;
        });

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
        if(button == 0 && !playerConnected) {
//            unit.pose = Poses.SPECIAL;
//            var wp: WorldPoint = gameWorld.screenToWorld(new Point(x, y));
//            unit.lookAt = wp;
            streamHandler.end();
            streamHandler.start();
        } else if(button == 1 && !playerConnected) {
            var playerConnect = new PlayerConnect();
            playerConnect.playerId = playerService.uniqueId;
            streamHandler.send(playerConnect);
            playerConnected = true;
//        } else if(button == 1 && playerConnected) {
//            var unitMoveTo = new UnitMoveTo();
//            var currentUnit: UnitVO = null;
//            for(unit in currentPlayer.units) {
//                currentUnit = unit;
//                break;
//            }
//            if(currentUnit != null) {
//                unitMoveTo.unitId = currentUnit.id;
//                var wp: WorldPoint = gameWorld.screenToWorld(new Point(x, y));
//                unitMoveTo.posX = Std.int(wp.x);
//                unitMoveTo.posZ = Std.int(wp.z);
//                streamHandler.send(unitMoveTo);
//            }
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
        hello.x = 400;
        topLayer.addChild(hello);

        var tween: Tween = objectCreator.createInstance(Tween);
        tween.to(hello, 3000, {x: 500, y: 500}).delay(2000);
//
//        unit = createUnit(1, 1);
//
//        var unitVO: MutableUnitVO = objectCreator.createInstance(MutableUnitVO);
//        unitVO.id = 1;
//        unitVO.unitType = 1;
//
//        var worldPoint: WorldPoint = gameWorld.screenToWorld(new Point(100, 100));
//        gameWorld.addGameObject(unit, worldPoint);
    }

    public function createUnit(unitId: Int, unitType: Int): GameObject {
        #if !test
        var unit: NecroGameObject = objectCreator.createInstance(NecroGameObject);
        unit.id = unitId + "";

        return unit;
        #else
        return null;
        #end
    }


}
