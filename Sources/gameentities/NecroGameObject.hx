package gameentities;
import constants.Poses;
import util.MathUtil;
import geom.Point;
import world.two.WorldPoint2D;
import world.WorldPoint;
import animation.Animation;
class NecroGameObject extends WizardGameObject {

    public var animation: Animation;
    public var display: NecroDisplay;

    public function new() {
        super();
    }

    override public function set_lookAt(value:WorldPoint): WorldPoint {
        var direction: Float = MathUtil.getDirectionInDegrees(worldPoint, value);
        direction = (direction + 180) % 360;
        var distanceBetweenDirections: Float = 360 / display.totalDirections;
        var animationDirection: UInt = Std.int((direction + (distanceBetweenDirections * 0.5)) / distanceBetweenDirections);
        display.setDirection(animationDirection);

        return value;
    }

    public function setPose(pose: Poses): Void {
        display.setPose(pose);
    }

}
