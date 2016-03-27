package gameentities;
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

        var wizard: BitmapNode = objectCreator.createInstance(BitmapNode);
        wizard.imageData = image;
        addChild(wizard);

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
        animation.bitmap = wizard;

        animationController = objectCreator.createInstance(AnimationController);
        animationController.animation = animation;
        animationController.start();
    }

    public function setDirection(index: Int): Void {
        animation.frames = directions[index % totalDirections].frames;
    }

}
