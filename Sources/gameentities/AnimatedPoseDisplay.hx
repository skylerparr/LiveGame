package gameentities;
import animation.AnimationWithEvents;
import haxe.Json;
import animation.Frame;
import geom.Point;
import assets.ImageAsset;
import animation.AnimationController;
import animation.spec.TexturePackerJSONArrayFrameSpec;
import display.BitmapNode;
import constants.Poses;
import animation.Animation;
import core.ObjectCreator;
import assets.AssetLocator;
import display.two.kha.KhaSprite;
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class AnimatedPoseDisplay extends KhaSprite {

    private static var point: Point = new Point();

    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var assetLocator: AssetLocator;

    public var animation: AnimationWithEvents;
    public var animationController: AnimationController;

    @:isVar
    public var totalDirections(get, null): Int;

    public function get_totalDirections():Int {
        return totalDirections;
    }

    private var imagePoses: Map<Poses, Dynamic>;
    private var bitmap: BitmapNode;

    private var directionPoseMap: Map<Poses, Array<TexturePackerJSONArrayFrameSpec>>;
    private var currentPoseFrames: Array<TexturePackerJSONArrayFrameSpec>;
    private var currentPose: Poses;
    private var currentDirection: Int;

    private var mapping: Array<AnimationPoseMapping>;

    public function new() {
        super();
    }

    override public function init():Void {
        super.init();
        directionPoseMap = new Map<Poses, Array<TexturePackerJSONArrayFrameSpec>>();
        imagePoses = new Map<Poses, Dynamic>();
    }

    public function generateAnimations(mapping: Array<AnimationPoseMapping>): Void {
        this.mapping = mapping;
        createDisplay(function(): Void {

        });
    }

    @:async
    private function createDisplay():Void {
        for(map in mapping) {
            var asset: ImageAsset = @await assetLocator.getAssetByName(map.assetName);
            imagePoses.set(map.pose, asset.data);
            directionPoseMap.set(map.pose, @await createFrames("_" + map.assetName, map.numberOfDirections, point));
        }

        var idle: Array<TexturePackerJSONArrayFrameSpec> = directionPoseMap.get(Poses.IDLE);
        totalDirections = idle.length;

        animation = objectCreator.createInstance(AnimationWithEvents);
        animation.frameTime = 70;

        bitmap = objectCreator.createInstance(BitmapNode);
        animation.bitmap = bitmap;
        setPose(Poses.IDLE);
        addChild(bitmap);

        animationController = objectCreator.createInstance(AnimationController);
        animationController.animation = animation;
        animationController.start();
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

        var firstFrame: Frame = currentPoseFrames[0].frames[0];
        bitmap.x = firstFrame.width * -0.5;
        bitmap.y = -firstFrame.height;
    }

    @:async
    private inline function createFrames(key:String, numberOfDirections: Int, offset: Point):Array<TexturePackerJSONArrayFrameSpec> {
        var retVal: Array<TexturePackerJSONArrayFrameSpec> = [];
        var poseIndex: String = "";
        for(i in 0...numberOfDirections) {
            poseIndex = i + "";
            if(i < 10) {
                poseIndex = "0" + poseIndex;
            }
            var jsonString = @await assetLocator.getDataAssetByName("_" + poseIndex + key + "_json");
            var pose = objectCreator.createInstance(TexturePackerJSONArrayFrameSpec,[Json.parse(cast jsonString), offset]);
            retVal.push(pose);
        }
        return retVal;
    }
}
