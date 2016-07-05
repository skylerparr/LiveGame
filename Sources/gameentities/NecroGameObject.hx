package gameentities;
import display.DisplayNode;
import world.WorldEntityDisplay;
import constants.Poses;
import util.MathUtil;
import world.WorldPoint;
import animation.Animation;
class NecroGameObject extends WizardGameObject implements WorldEntityDisplay {

    public var animation: Animation;

    public var display(get, set):DisplayNode;

    function set_display(value:DisplayNode): DisplayNode {
        this.thisDisplay = cast value;
        return this.thisDisplay;
    }

    function get_display():DisplayNode {
        return thisDisplay;
    }

    private var thisDisplay: NecroDisplay;

    public function new() {
        super();
    }

    override public function set_lookAt(value:WorldPoint): WorldPoint {
        var direction: Float = MathUtil.getDirectionInDegrees(worldPoint, value);
        direction = (direction + 180) % 360;
        var distanceBetweenDirections: Float = 360 / thisDisplay.totalDirections;
        var animationDirection: UInt = Std.int((direction + (distanceBetweenDirections * 0.5)) / distanceBetweenDirections);
        thisDisplay.setDirection(animationDirection);

        return value;
    }

    override public function set_pose(value:Poses):Poses {
        this.pose = value;
        thisDisplay.setPose(pose);
        return value;
    }

}
