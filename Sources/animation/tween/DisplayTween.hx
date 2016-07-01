package animation.tween;
import display.DisplayNode;
class DisplayTween extends SimpleTween {

    private var targetProps: DisplayProperties;
    private var displayTarget: DisplayNode;

    public function new() {
        super();
    }

    override public function to(target:Dynamic, duration:UInt, properties:Dynamic):TweenTarget {
        displayTarget = cast target;
        targetProps = {x: 0, y: 0, z: 0, width: 0, height: 0, depth: 0, scaleX: 0, scaleY: 0, scaleZ: 0};
        return super.to(target, duration, properties);
    }

    override public function updateFields(percentComplete:Float):Void {
        displayTarget.x = targetProps.x + (originalProperties.x - targetProps.x) * percentComplete;
        displayTarget.y = targetProps.y + (originalProperties.y - targetProps.y) * percentComplete;
        displayTarget.z = targetProps.z + (originalProperties.z - targetProps.z) * percentComplete;
        displayTarget.z = targetProps.width + (originalProperties.width - targetProps.width) * percentComplete;
        displayTarget.z = targetProps.height + (originalProperties.height - targetProps.height) * percentComplete;
        displayTarget.z = targetProps.depth + (originalProperties.depth - targetProps.depth) * percentComplete;
        displayTarget.z = targetProps.scaleX + (originalProperties.scaleX - targetProps.scaleX) * percentComplete;
        displayTarget.z = targetProps.scaleY + (originalProperties.scaleY - targetProps.scaleY) * percentComplete;
        displayTarget.z = targetProps.scaleZ + (originalProperties.scaleZ - targetProps.scaleZ) * percentComplete;
    }

    override public function storeOriginalTargetValues():Void {
        var fields: Array<String> = Reflect.fields(targetProps);
        for(field in fields) {
            Reflect.setProperty(targetProps, field, Reflect.getProperty(displayTarget, field));
        }
    }
}

typedef DisplayProperties = {
    x: Float,
    y: Float,
    z: Float,
    width: Float,
    height: Float,
    depth: Float,
    scaleX: Float,
    scaleY: Float,
    scaleZ: Float
}
