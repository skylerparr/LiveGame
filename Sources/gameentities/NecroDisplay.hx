package gameentities;
import constants.Poses;
import animation.Frame;
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

    @:isVar
    public var totalDirections(get, null): Int;

    public function get_totalDirections():Int {
        return totalDirections;
    }

    private var imagePoses: Map<Poses, Image>;
    private var bitmap: BitmapNode;

    private var directionPoseMap: Map<Poses, Array<TexturePackerJSONArrayFrameSpec>>;
    private var currentPoseFrames: Array<TexturePackerJSONArrayFrameSpec>;
    private var currentPose: Poses;
    private var currentDirection: Int;

    private var animationController: AnimationController;

    public function new() {
        super();
    }

    override public function init():Void {
        super.init();
        directionPoseMap = new Map<Poses, Array<TexturePackerJSONArrayFrameSpec>>();
        imagePoses = new Map<Poses, Image>();

        createDisplay(function(): Void {

        });
    }

    @:async
    private function createDisplay():Void {
        imagePoses.set(Poses.IDLE, @await Assets.loadImage("necro_idle"));
        imagePoses.set(Poses.RUN, @await Assets.loadImage("necro_run"));

        directionPoseMap.set(Poses.IDLE, @await createFrames("_necro_idle_json"));
        directionPoseMap.set(Poses.RUN, @await createFrames("_necro_run_json"));

        var idle: Array<TexturePackerJSONArrayFrameSpec> = directionPoseMap.get(Poses.IDLE);
        totalDirections = idle.length;

        animation = objectCreator.createInstance(Animation);
        animation.frameTime = 70;

        bitmap = objectCreator.createInstance(BitmapNode);
        animation.bitmap = bitmap;
        setPose(Poses.IDLE);
        addChild(bitmap);

        animationController = objectCreator.createInstance(AnimationController);
        animationController.animation = animation;
        animationController.start();

        var firstFrame: Frame = currentPoseFrames[0].frames[0];
        bitmap.x = firstFrame.width * -0.5;
        bitmap.y = firstFrame.height * -0.5;
    }

    public function setDirection(index: Int): Void {
        currentDirection = index;
        animation.frames = currentPoseFrames[currentDirection % totalDirections].frames;
    }

    public function setPose(pose: Poses): Void {
        currentPose = pose;
        bitmap.imageData = imagePoses.get(currentPose);
        currentPoseFrames = directionPoseMap.get(currentPose);
        setDirection(currentDirection);
    }

    @:async
    private inline function createFrames(key:String):Array<TexturePackerJSONArrayFrameSpec> {
        var retVal: Array<TexturePackerJSONArrayFrameSpec> = [];
        var poseIndex: String = "";
        for(i in 0...15) {
            poseIndex = i + "";
            if(i < 10) {
                poseIndex = "0" + poseIndex;
            }
            var jsonString = @await Assets.loadBlob("_" + poseIndex + key);
            var pose = objectCreator.createInstance(TexturePackerJSONArrayFrameSpec,[Json.parse(cast jsonString)]);
            retVal.push(pose);
        }
        return retVal;
    }
}
