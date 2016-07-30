package gameentities.fx;
import animation.AnimationWithEvents;
import constants.LayerNames;
import display.DisplayNodeContainer;
import constants.Poses;
import world.WorldPoint;
import geom.Point;
import assets.AssetLocator;
import core.ObjectCreator;
import display.LayerManager;
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class UnitSpawnFX implements SpecialEffect {
    private static var point: Point = new Point();

    @inject("world")
    public var layerManager: LayerManager;
    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var assetLocator: AssetLocator;

    private var animatedPoseDisplay: AnimatedPoseDisplay;
    private var container: DisplayNodeContainer;

    public function new() {
    }

    public function init():Void {
        container = layerManager.getLayerByName(LayerNames.FX);
    }

    public function dispose():Void {
    }

    public function begin(worldPoint: WorldPoint):Void {
        animatedPoseDisplay = objectCreator.createInstance(AnimatedPoseDisplay);
        animatedPoseDisplay.generateAnimations([
            {pose: Poses.IDLE, assetName: "spawn_unit_begin", numberOfDirections: 1},
            {pose: Poses.RUN, assetName: "spawn_unit_repeat", numberOfDirections: 1},
            {pose: Poses.DIE, assetName: "spawn_unit_end", numberOfDirections: 1}
        ]);
        animatedPoseDisplay.x = worldPoint.x;
        animatedPoseDisplay.y = worldPoint.z + 50;

        animatedPoseDisplay.animation.subscribeOnComplete(onIdleComplete);

        container.addChild(animatedPoseDisplay);
    }

    private function onIdleComplete(animation: AnimationWithEvents):Void {
        animatedPoseDisplay.setPose(Poses.RUN);
    }

    public function end(onComplete:SpecialEffect->Void):Void {
        endAnimation(function(): Void {
            if(onComplete != null) {
                onComplete(this);
            }
        });
    }

    @:async
    private function endAnimation():Void {
        animatedPoseDisplay.setPose(Poses.DIE);
        animatedPoseDisplay.animation.subscribeOnComplete(onDieComplete);
    }

    private function onDieComplete(animation:AnimationWithEvents):Void {
        container.removeChild(animatedPoseDisplay);
        animatedPoseDisplay.animation.unsubscribeOnComplete(onDieComplete);
        objectCreator.disposeInstance(animatedPoseDisplay);
    }

}
