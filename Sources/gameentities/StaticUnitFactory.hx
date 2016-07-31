package gameentities;
import gameentities.AnimatedPoseDisplay;
import core.ObjectCreator;
import constants.Poses;
import world.GameObject;
class StaticUnitFactory implements UnitFactory {

    @inject
    public var objectCreator: ObjectCreator;
    
    private var mapping: Map<String, Array<AnimationPoseMapping>>;

    public function new() {
    }

    public function init():Void {
        mapping = new Map<String, Array<AnimationPoseMapping>>();

        mapping.set("1", [
            {pose: Poses.IDLE, assetName: "necro_idle", numberOfDirections: 16},
            {pose: Poses.RUN, assetName: "necro_run", numberOfDirections: 16},
            {pose: Poses.SPECIAL, assetName: "necro_special", numberOfDirections: 16}
        ]);
        mapping.set("2", [
            {pose: Poses.IDLE, assetName: "zombie_idle", numberOfDirections: 8},
            {pose: Poses.RUN, assetName: "zombie_run", numberOfDirections: 8}
        ]);
    }

    public function dispose():Void {
        mapping = null;
        objectCreator = null;
    }

    public function createUnitDisplayByUnitTypeId(unitType:String):AnimatedPoseDisplay {
        var animatedDisplay: AnimatedPoseDisplay = objectCreator.createInstance(AnimatedPoseDisplay);
        animatedDisplay.generateAnimations(mapping.get(unitType));
        return animatedDisplay;
    }

}
