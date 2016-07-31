package scenes.playground;
import assets.ImageAsset;
import assets.AssetLocator;
import io.InputOutputStream;
import world.GameObject;
import world.WorldPoint;
import motion.easing.Bounce;
import motion.easing.Sine;
import animation.tween.Tween;
import motion.Actuate;
import vo.PlayerVO;
import service.PlayerService;
import handler.output.PlayerConnect;
import handler.StreamHandler;
import gameentities.InteractiveGameObject;
import world.two.WorldPoint2D;
import util.Subscriber;
import world.GameWorld;
import constants.LayerNames;
import display.TextFieldNode;
import display.DisplayNodeContainer;
import display.BitmapNode;
import display.DisplayNode;
import core.BaseObject;
import display.LayerManager;
import core.ObjectCreator;
@IgnoreCover
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
    @inject
    public var assetLocator: AssetLocator;

    private var lastUnit: InteractiveGameObject;
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
            playerService.getCurrentPlayer(function(p: PlayerVO): Void {
                currentPlayer = p;
                if(!playerConnected) {
                    streamHandler.end();
                    streamHandler.unsubscribeToConnected(onConnected);
                    streamHandler.unsubscribeToClose(onClosed);
                    streamHandler.subscribeToConnected(onConnected);
                    streamHandler.subscribeToClose(onClosed);
                    streamHandler.start();
                }
            });
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

    private function onConnected(stream: InputOutputStream): Void {
        var playerConnect = new PlayerConnect();
        playerConnect.playerId = playerService.uniqueId;
        streamHandler.send(playerConnect);
        playerConnected = true;
    }

    private function onClosed(stream:InputOutputStream):Void {
        streamHandler.end();
        playerConnected = false;
        streamHandler.unsubscribeToConnected(onConnected);
        streamHandler.unsubscribeToClose(onClosed);
    }

    public function dispose():Void {
    }

    @:async
    private function showPlayground():Void {
        var bottomLayer: DisplayNodeContainer = layerManager.getLayerByName(LayerNames.TERRAIN);
        var middleLayer: DisplayNodeContainer = layerManager.getLayerByName(LayerNames.GAME_OBJECTS);

        var grumpyCat: BitmapNode = objectCreator.createInstance(BitmapNode);
        var image:ImageAsset = @await assetLocator.getAssetByName("grumpy_cat_nope");
        grumpyCat.imageData = image.data;
        grumpyCat.sx = 0;
        grumpyCat.sy = 0;
        grumpyCat.sw = image.width;
        grumpyCat.sh = image.height;
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
    }

    public function createUnit(unitId: Int, unitType: Int): GameObject {
        #if !test
        var unit: InteractiveGameObject = objectCreator.createInstance(InteractiveGameObject);
        unit.id = unitId + "";

        return unit;
        #else
        return null;
        #end
    }


}
