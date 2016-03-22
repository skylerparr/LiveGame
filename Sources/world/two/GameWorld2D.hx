package world.two;
import display.DisplayNode;
import geom.Point;
class GameWorld2D implements GameWorld {

    @inject
    public var viewPort: ViewPort;

    private var point: Point;
    private var worldPoint: WorldPoint2D;

    public function new() {
    }

    @:isVar
    public var gameObjects(get, set):List<GameObject>;
    @:isVar
    public var totalHeight(get, set):Float;
    @:isVar
    public var totalWidth(get, set):Float;

    public function get_gameObjects():List<GameObject> {
        return gameObjects;
    }

    public function set_gameObjects(value:List<GameObject>) {
        return this.gameObjects = value;
    }

    public function set_totalHeight(value:Float) {
        return this.totalHeight = value;
    }

    public function get_totalHeight():Float {
        return totalHeight;
    }

    public function set_totalWidth(value:Float) {
        return this.totalWidth = value;
    }

    public function get_totalWidth():Float {
        return totalWidth;
    }

    public function init():Void {
        point = new Point();
        worldPoint = new WorldPoint2D();
    }

    public function dispose():Void {
        point = null;
        worldPoint = null;
    }

    public function addGameObject(gameObject:GameObject, worldPt:WorldPoint):Void {
    }

    public function moveItemTo(item:GameObject, worldPt:WorldPoint):Void {
    }

    public function removeGameObject(gameObject:GameObject):Void {
    }

    public function removeAllObjects():Void {
    }

    public function getDisplayByGameObject(gameObject:GameObject):DisplayNode {
        return null;
    }

    public function getGameObjectById(id:String):GameObject {
        return null;
    }

    public function getItemAt(worldPoint:WorldPoint):GameObject {
        return null;
    }

    public function worldToScreen(wp:WorldPoint):Point {
        point.x = viewPort.x - wp.x;
        point.y = viewPort.y - wp.y;
        return point;
    }

    public function screenToWorld(point:Point):WorldPoint {
        worldPoint.x = viewPort.x + point.x;
        worldPoint.y = viewPort.y + point.y;
        return worldPoint;
    }
}
