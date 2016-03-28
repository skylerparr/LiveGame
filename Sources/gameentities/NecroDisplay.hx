package gameentities;
import animation.Frame;
import Reflect;
import display.two.kha.KhaSprite;
import core.ObjectCreator;
import kha.Image;
import display.BitmapNode;
import kha.Assets;
import animation.spec.TexturePackerJSONArrayFrameSpec;
import haxe.Json;
import animation.Animation;
import animation.AnimationController;
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class NecroDisplay extends KhaSprite {
    @inject
    public var objectCreator: ObjectCreator;

    public var animation: Animation;
    public var totalDirections(get, null): Int;

    public function get_totalDirections():Int {
        return directions.length;
    }

    private var directions: Array<TexturePackerJSONArrayFrameSpec>;
    private var animationController: AnimationController;
    private var image: Image;

    public function new() {
        super();
    }

    override public function init():Void {
        super.init();
        directions = [];
        createDisplay(function(): Void {

        });
    }

    @:async
    private function createDisplay():Void {
        image = @await Assets.loadImage("necro_run");

        var bitmap: BitmapNode = objectCreator.createInstance(BitmapNode);
        bitmap.imageData = image;
        addChild(bitmap);

        var poseIndex: String = "";
        for(i in 0...15) {
            poseIndex = i + "";
            if(i < 10) {
                poseIndex = "0" + poseIndex;
            }
            var jsonString = @await Assets.loadBlob("_" + poseIndex + "_necro_json");
            var pose = objectCreator.createInstance(TexturePackerJSONArrayFrameSpec,[Json.parse(cast jsonString)]);
            directions.push(pose);
        }

        animation = objectCreator.createInstance(Animation);
        animation.frameTime = 70;
        animation.frames = directions[0].frames;
        animation.bitmap = bitmap;

        animationController = objectCreator.createInstance(AnimationController);
        animationController.animation = animation;
        animationController.start();

        var firstFrame: Frame = directions[0].frames[0];
        bitmap.x = firstFrame.width * -0.5;
        bitmap.y = firstFrame.height * -0.5;
    }

    public function setDirection(index: Int): Void {
        animation.frames = directions[index % totalDirections].frames;
    }

}
