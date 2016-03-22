package world.two;
import display.DisplayNode;
import units.EntityFactory;
import constants.LayerNames;
import display.DisplayNodeContainer;
import display.LayerManager;
import geom.Point;
class GameWorld2D implements GameWorld {

    @inject
    public var viewPort: ViewPort;
    @inject("world")
    public var layerManger: LayerManager;
    @inject
    public var entityFactory: EntityFactory;

    private var point: Point;
    private var worldPoint: WorldPoint2D;

    private var gameObjectLayer: DisplayNodeContainer;
    private var objectToDisplayMap: Map<WorldEntity, DisplayNode>;

    public function new() {
    }

    @:isVar
    public var gameObjects(get, set):List<WorldEntity>;
    @:isVar
    public var totalHeight(get, set):Float;
    @:isVar
    public var totalWidth(get, set):Float;

    public function get_gameObjects():List<WorldEntity> {
        return gameObjects;
    }

    public function set_gameObjects(value:List<WorldEntity>) {
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

        gameObjectLayer = layerManger.getLayerByName(LayerNames.GAME_OBJECTS);
        gameObjects = new List<WorldEntity>();
        objectToDisplayMap = new Map<WorldEntity, DisplayNode>();
    }

    public function dispose():Void {
        point = null;
        worldPoint = null;
    }

    public function addGameObject(worldEntity:WorldEntity, worldPt:WorldPoint):Void {
        var display: DisplayNode = entityFactory.createViewForEntity(worldEntity);
        setDisplayAndGameObjectLocation(worldEntity, display, worldPt);

        gameObjects.add(worldEntity);
        objectToDisplayMap.set(worldEntity, display);
        gameObjectLayer.addChild(display);
    }

    public function moveItemTo(gameObject:WorldEntity, worldPt:WorldPoint):Void {
        var display: DisplayNode = objectToDisplayMap.get(gameObject);
        if(display != null) {
            setDisplayAndGameObjectLocation(gameObject, display, worldPt);
        }
    }

    private inline function setDisplayAndGameObjectLocation(worldEntity: WorldEntity, display: DisplayNode, worldPt: WorldPoint):Void {
        worldEntity.x = worldPt.x;
        display.x = worldPt.x;
        worldEntity.y = worldPt.y;
        display.y = worldPt.y;
    }

    public function removeGameObject(gameObject:WorldEntity):Void {
    }

    public function removeAllObjects():Void {
    }

    public function getDisplayByGameObject(gameObject:WorldEntity):DisplayNode {
        return null;
    }

    public function getGameObjectById(id:String):WorldEntity {
        return null;
    }

    public function getItemAt(worldPoint:WorldPoint):WorldEntity {
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
