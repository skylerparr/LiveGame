package gameentities;
import geom.Rectangle;
import world.two.Footprint2D;
import display.DisplayNode;
import world.WorldEntityDisplay;
import constants.Poses;
import util.MathUtil;
import world.WorldPoint;
import animation.Animation;
class InteractiveGameObject extends BaseGameObject implements WorldEntityDisplay {

    public var animation: Animation;

    public var display(get, set):DisplayNode;

    function set_display(value:DisplayNode): DisplayNode {
        this.thisDisplay = cast value;
        footprint.footprint = new Rectangle(value.width * -0.5, -value.height, value.width, value.height);
        return this.thisDisplay;
    }

    function get_display():DisplayNode {
        return thisDisplay;
    }

    private var thisDisplay: AnimatedPoseDisplay;

    public function new() {
        super();
    }

    override public function init():Void {
        super.init();
        footprint = new Footprint2D();
        footprint.footprint = new Rectangle(0, 0, 0, 0);
    }

    override public function dispose():Void {
        thisDisplay = null;
        animation = null;
        super.dispose();
    }

    override public function set_lookAt(value:WorldPoint): WorldPoint {
        if(thisDisplay == null) {
            return value;
        }
        var direction: Float = MathUtil.getDirectionInDegrees(worldPoint, value);
        direction = (direction + 180) % 360;
        var distanceBetweenDirections: Float = 360 / thisDisplay.totalDirections;
        var animationDirection: UInt = Std.int((direction + (distanceBetweenDirections * 0.5)) / distanceBetweenDirections);
        thisDisplay.setDirection(animationDirection);

        return value;
    }

    override public function set_pose(value:Poses):Poses {
        if(thisDisplay == null) {
            return value;
        }
        this.pose = value;
        thisDisplay.setPose(pose);
        return value;
    }

}
