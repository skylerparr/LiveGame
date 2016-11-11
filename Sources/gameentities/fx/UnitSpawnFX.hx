package gameentities.fx;
import animation.AnimationWithEvents;
import constants.LayerNames;
import display.DisplayNodeContainer;
import constants.Poses;
import world.WorldPoint;
import assets.AssetLocator;
import core.ObjectCreator;
import display.LayerManager;
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class UnitSpawnFX implements SpecialEffect {

    @inject("world")
    public var layerManager: LayerManager;
    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var assetLocator: AssetLocator;

    public var animatedPoseDisplay: AnimatedPoseDisplay;
    public var container: DisplayNodeContainer;

    public function new() {
    }

    public function init():Void {
        container = layerManager.getLayerByName(LayerNames.FX);
    }

    public function dispose():Void {
        disposeAnimation();

        container = null;
        animatedPoseDisplay = null;
        layerManager = null;
        objectCreator = null;
        assetLocator = null;
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
        animatedPoseDisplay.animation.unsubscribeOnComplete(onIdleComplete);
        animatedPoseDisplay.setPose(Poses.RUN);
    }

    public function end(onComplete:SpecialEffect->Void):Void {
        if(animatedPoseDisplay == null) {
            if(onComplete != null) {
                onComplete(this);
            }
            return;
        }
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
        animatedPoseDisplay.animation.unsubscribeOnComplete(onDieComplete);
    }

    private inline function disposeAnimation():Void {
        if(container != null) {
            container.removeChild(animatedPoseDisplay);
        }
        if(animatedPoseDisplay != null) {
            animatedPoseDisplay.animation.unsubscribeOnComplete(onIdleComplete);
            animatedPoseDisplay.animation.unsubscribeOnComplete(onDieComplete);
        }
        if(objectCreator != null) {
            objectCreator.disposeInstance(animatedPoseDisplay);
        }
    }

}
