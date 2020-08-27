package world.two;
import geom.Rectangle;
import display.DisplayNode;
import units.EntityFactory;
import constants.LayerNames;
import display.DisplayNodeContainer;
import display.LayerManager;
import geom.Point;
class GameWorld2D implements GameWorldDisplay {

    @inject
    public var viewPort: ViewPort;
    @inject("world")
    public var layerManger: LayerManager;
    @inject
    public var entityFactory: EntityFactory;

    public var point: Point;
    public var worldPoint: WorldPoint2D;

    public var gameObjectLayer: DisplayNodeContainer;
    public var objectToDisplayMap: Map<WorldEntity, DisplayNode>;
    public var entityIndex: Map<Int, WorldEntity>;
    public var displayToObjectMap: Map<DisplayNode, WorldEntity>;

    public function new() {
    }

    @:isVar
    public var gameObjects(get, set):List<WorldEntity>;
    @:isVar
    public var totalHeight(get, set):Float;
    @:isVar
    public var totalWidth(get, set):Float;

    public var displayContainer(get, set): DisplayNodeContainer;

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

    public function get_displayContainer():DisplayNodeContainer {
        return this.gameObjectLayer;
    }

    public function set_displayContainer(value:DisplayNodeContainer) {
        return this.gameObjectLayer = value;
    }

    public function init():Void {
        point = new Point();
        worldPoint = new WorldPoint2D();

        gameObjectLayer = layerManger.getLayerByName(LayerNames.GAME_OBJECTS);
        gameObjects = new List<WorldEntity>();
        objectToDisplayMap = new Map<WorldEntity, DisplayNode>();
        entityIndex = new Map<Int, WorldEntity>();
        displayToObjectMap = new Map<DisplayNode, WorldEntity>();
    }

    public function dispose():Void {
        point = null;
        worldPoint = null;
        viewPort = null;
        layerManger = null;
        entityFactory = null;
        gameObjectLayer = null;
        objectToDisplayMap = null;
        entityIndex = null;
        gameObjects = null;
        displayToObjectMap = null;
    }

    public function addGameObject(worldEntity:WorldEntity, worldPt:WorldPoint):Void {
        if(worldEntity == null || worldPt == null) {
            return;
        }
        if(objectToDisplayMap.exists(worldEntity)) {
            return;
        }
        var display: DisplayNode = entityFactory.createViewForEntity(worldEntity);
        if(display == null) {
            return;
        }
        setDisplayAndGameObjectLocation(worldEntity, display, worldPt);

        gameObjects.add(worldEntity);
        objectToDisplayMap.set(worldEntity, display);
        gameObjectLayer.addChild(display);
        entityIndex.set(worldEntity.id, worldEntity);

        if(Std.is(worldEntity, WorldEntityDisplay)) {
            cast(worldEntity, WorldEntityDisplay).display = display;
            displayToObjectMap.set(display, worldEntity);
        }
    }

    public function moveItemTo(gameObject:WorldEntity, worldPt:WorldPoint):Void {
        if(worldPt == null) {
            return;
        }
        var display: DisplayNode = objectToDisplayMap.get(gameObject);
        if(display != null) {
            setDisplayAndGameObjectLocation(gameObject, display, worldPt);
        }
    }

    private inline function setDisplayAndGameObjectLocation(worldEntity: WorldEntity, display: DisplayNode, worldPt: WorldPoint):Void {
        worldEntity.x = worldPt.x;
        display.x = worldPt.x;
        worldEntity.z = worldPt.z;
        display.y = worldPt.z;
    }

    public function removeGameObject(gameObject:WorldEntity):Void {
        if(gameObject == null) {
            return;
        }
        var display: DisplayNode = objectToDisplayMap.get(gameObject);
        if(display == null) {
            return;
        }
        entityFactory.disposeViewForEntity(gameObject, display);
        objectToDisplayMap.remove(gameObject);
        displayToObjectMap.remove(display);
        gameObjects.remove(gameObject);
        entityIndex.remove(gameObject.id);
    }

    public function removeAllObjects():Void {
        for(entity in gameObjects) {
            removeGameObject(entity);
        }
    }

    public function getDisplayByGameObject(gameObject:WorldEntity):DisplayNode {
        return objectToDisplayMap.get(gameObject);
    }

    public function getWorldEntityByDisplay(displayNode:DisplayNode):WorldEntity {
        return displayToObjectMap.get(displayNode);
    }

    public function getGameObjectById(id:Int):WorldEntity {
        return entityIndex.get(id);
    }

    public function getItemAt(worldPoint:WorldPoint):WorldEntity {
        if(worldPoint == null) {
            return null;
        }
        var rect: Rectangle = new Rectangle();

        var retVal: WorldEntity = null;
        for(entity in gameObjects) {
            var footprintRect: Rectangle = entity.footprint.footprint;
            var entityLocation: WorldPoint = entity.worldPoint;

            rect.x = entityLocation.x + footprintRect.x;
            rect.y = entityLocation.z + footprintRect.y;
            rect.width = footprintRect.width;
            rect.height = footprintRect.height;

            if(rect.contains(worldPoint.x, worldPoint.z)) {
                return entity;
            }
        }
        return retVal;
    }

    public function worldToScreen(wp:WorldPoint):Point {
        point.x = wp.x - viewPort.x;
        point.y = wp.z - viewPort.y;
        return point;
    }

    public function screenToWorld(point:Point):WorldPoint {
        worldPoint.x = viewPort.x + point.x;
        worldPoint.z = viewPort.y + point.y;
        return worldPoint;
    }
}
