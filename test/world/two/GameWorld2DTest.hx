package world.two;

import world.WorldEntity;
import units.EntityFactory;
import mocks.MockViewPort;
import mocks.MockDisplayNodeContainer;
import mocks.MockGameObject;
import display.DisplayNodeContainer;
import constants.LayerNames;
import display.LayerManager;
import geom.Rectangle;
import display.DisplayNode;
import geom.Point;
import massive.munit.Assert;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class GameWorld2DTest {

    private var gameWorld: GameWorld2D;
    private var viewPort: MockViewPort;
    private var layerManager: LayerManager;
    private var gameLayer: MockDisplayNodeContainer;
    private var entityFactory: EntityFactory;
    private var wp: WorldPoint2D;
    private var point: Point;

    public function new() {

    }

    @Before
    public function setup():Void {
        viewPort = mock(MockViewPort);
        wp = new WorldPoint2D();
        point = new Point();
        layerManager = mock(LayerManager);
        gameLayer = mock(MockDisplayNodeContainer);
        entityFactory = mock(EntityFactory);

        layerManager.getLayerByName(LayerNames.GAME_OBJECTS).returns(gameLayer);

        gameWorld = new GameWorld2D();
        gameWorld.viewPort = viewPort;
        gameWorld.layerManger = layerManager;
        gameWorld.entityFactory = entityFactory;
        gameWorld.init();
    }

    @After
    public function tearDown():Void {
        viewPort = null;
    }

    @Test
    public function shouldGetOriginWhenViewPortHasntTranslated(): Void {
        viewPort.x.returns(0);
        viewPort.y.returns(0);

        var p: Point = gameWorld.worldToScreen(wp);

        Assert.areEqual(0, p.x);
        Assert.areEqual(0, p.y);
    }

    @Test
    public function shouldGetViewPortTranslatedValueIfGetPointAtZeroZero(): Void {
        viewPort.x.returns(20);
        viewPort.y.returns(32);

        wp.x = 20;
        wp.z = 32;
        var p: Point = gameWorld.worldToScreen(wp);

        Assert.areEqual(0, p.x);
        Assert.areEqual(0, p.y);
    }

    @Test
    public function shouldGiveTranslatedPointWhenViewPortIsTranslated(): Void {
        viewPort.x.returns(20);
        viewPort.y.returns(32);

        wp.x = 14;
        wp.z = 18;
        var p: Point = gameWorld.worldToScreen(wp);

        Assert.areEqual(6, p.x);
        Assert.areEqual(14, p.y);
    }

    @Test
    public function shouldGiveZeroZeroIfViewPortIsNotTranslatedAndGetWorldPointOrigin(): Void {
        viewPort.x.returns(0);
        viewPort.y.returns(0);

        var wp: WorldPoint = gameWorld.screenToWorld(point);

        Assert.areEqual(0, wp.x);
        Assert.areEqual(0, wp.z);
    }

    @Test
    public function shouldGiveTranslatedValueIfViewPortHasMoved(): Void {
        viewPort.x.returns(10);
        viewPort.y.returns(20);

        var wp: WorldPoint = gameWorld.screenToWorld(point);

        Assert.areEqual(10, wp.x);
        Assert.areEqual(20, wp.z);
    }

    @Test
    public function shouldGiveTranslatedWorldPointIfViewPortMovedAndNotAtOrigin(): Void {
        viewPort.x.returns(10);
        viewPort.y.returns(20);

        point.x = 15;
        point.y = 26;
        var wp: WorldPoint = gameWorld.screenToWorld(point);

        Assert.areEqual(25, wp.x);
        Assert.areEqual(46, wp.z);
    }

    @Test
    public function shouldAddTheUnitToTheGameWorldAtASpecificWorldPoint(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);

        entityFactory.createViewForEntity(gameObject).returns(display);

        wp.x = 83;
        wp.z = 347;
        gameWorld.addGameObject(gameObject, wp);

        Assert.areEqual(1, getGameObjectCount());
        Assert.areEqual(gameObject, gameWorld.gameObjects.pop());

        gameLayer.addChild(display).verify();
        display.set_x(83).verify();
        display.set_y(347).verify();
        gameObject.set_x(83).verify();
        gameObject.set_z(347).verify();
    }

    @Test
    public function shouldMoveDisplayToDesiredLocation(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);

        entityFactory.createViewForEntity(gameObject).returns(display);

        wp.x = 83;
        wp.z = 347;
        gameWorld.addGameObject(gameObject, wp);
        wp.x = 23;
        wp.z = 47;
        gameWorld.moveItemTo(gameObject, wp);

        display.set_x(23).verify();
        display.set_y(47).verify();
        gameObject.set_x(23).verify();
        gameObject.set_z(47).verify();
    }

    @Test
    public function shouldNotAddEntityToWorldIfNull(): Void {
        gameWorld.addGameObject(null, wp);
        Assert.areEqual(0, getGameObjectCount());
    }

    @Test
    public function shouldNotAddEntityToTheWorldIfEntityFactoryReturnsNull(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        entityFactory.createViewForEntity(gameObject).returns(null);
        gameWorld.addGameObject(gameObject, wp);
        Assert.areEqual(0, getGameObjectCount());
    }

    @Test
    public function shouldMoveNullEntity(): Void {
        try {
            gameWorld.moveItemTo(null, wp);
            Assert.isTrue(true);
        } catch(e: Dynamic) {
            Assert.fail("can move null entity");
        }
    }

    @Test
    public function shouldNotAddEntityWithNullWorldPoint(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);

        entityFactory.createViewForEntity(gameObject).returns(display);

        gameWorld.addGameObject(gameObject, null);
    }

    @Test
    public function shouldNotMoveEntityWithNullWorldPoint(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);

        entityFactory.createViewForEntity(gameObject).returns(display);

        gameWorld.addGameObject(gameObject, wp);

        try {
            gameWorld.moveItemTo(gameObject, null);
            Assert.isTrue(true);
        } catch(e: Dynamic) {
            Assert.fail("can move null entity");
        }
    }

    @Test
    public function shouldRemoveEntityFromWorld(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);

        entityFactory.createViewForEntity(gameObject).returns(display);
        gameWorld.addGameObject(gameObject, wp);
        gameWorld.removeGameObject(gameObject);

        entityFactory.disposeViewForEntity(gameObject, display).verify();
        Assert.areEqual(0, getGameObjectCount());
    }

    @Test
    public function shouldNotRemoveNullEntity(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);

        entityFactory.createViewForEntity(gameObject).returns(display);
        gameWorld.addGameObject(gameObject, wp);
        gameWorld.removeGameObject(null);

        entityFactory.disposeViewForEntity(cast any, cast any).verify(0);
    }

    @Test
    public function shouldNotRemoveEntityIfNoDisplayIsFound(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        gameWorld.removeGameObject(gameObject);
        entityFactory.disposeViewForEntity(cast any, cast any).verify(0);
    }

    @Test
    public function shouldRemoveAllEntities(): Void {
        for(i in 0...10) {
            var gameObject: MockGameObject = mock(MockGameObject);
            var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);

            entityFactory.createViewForEntity(gameObject).returns(display);
            gameWorld.addGameObject(gameObject, wp);
        }
        Assert.areEqual(10, getGameObjectCount());
        gameWorld.removeAllObjects();

        Assert.areEqual(0, getGameObjectCount());
        entityFactory.disposeViewForEntity(cast any, cast any).verify(10);
    }

    @Test
    public function shouldGetDisplayForWorldEntity(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);

        entityFactory.createViewForEntity(gameObject).returns(display);

        gameWorld.addGameObject(gameObject, wp);

        Assert.areEqual(display, gameWorld.getDisplayByGameObject(gameObject));
    }

    @Test
    public function shouldGetWorldEntityById(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        gameObject.id.returns("12");
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);

        entityFactory.createViewForEntity(gameObject).returns(display);

        gameWorld.addGameObject(gameObject, wp);

        Assert.areEqual(gameObject, gameWorld.getGameObjectById("12"));
    }

    @Test
    public function shouldNotBeAbleToAddTheSameEntityTwice(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);

        entityFactory.createViewForEntity(gameObject).returns(display);
        gameWorld.addGameObject(gameObject, wp);

        entityFactory.createViewForEntity(gameObject).returns(display);
        gameWorld.addGameObject(gameObject, wp);

        Assert.areEqual(1, getGameObjectCount());
    }

    @Test
    public function shouldGetEntityFromWorldPoint(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);

        entityFactory.createViewForEntity(gameObject).returns(display);

        var footprint: Footprint2D = new Footprint2D();
        footprint.footprint = new Rectangle(0, 0, 30, 20);
        gameObject.footprint.returns(footprint);
        gameObject.worldPoint.returns(new WorldPoint2D(83, 347));
        wp.x = 83;
        wp.z = 347;

        gameWorld.addGameObject(gameObject, wp);

        var entity: WorldEntity = gameWorld.getItemAt(new WorldPoint2D(3, 200));
        Assert.isNull(entity);

        entity = gameWorld.getItemAt(new WorldPoint2D(100, 350));
        Assert.areEqual(gameObject, entity);
    }

    @Test
    public function shouldGetEntityFromWorldPointWithFootPrintOffset(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);

        entityFactory.createViewForEntity(gameObject).returns(display);

        var footprint: Footprint2D = new Footprint2D();
        footprint.footprint = new Rectangle(5, 10, 30, 20);
        gameObject.footprint.returns(footprint);
        gameObject.worldPoint.returns(new WorldPoint2D(83, 347));
        wp.x = 83;
        wp.z = 347;

        gameWorld.addGameObject(gameObject, wp);

        var entity: WorldEntity = gameWorld.getItemAt(new WorldPoint2D(85, 350));
        Assert.isNull(entity);

        entity = gameWorld.getItemAt(new WorldPoint2D(100, 360));
        Assert.areEqual(gameObject, entity);
    }

    @Test
    public function shouldReturnNullIfPassingNullWorldPointToGetItemAt(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);

        entityFactory.createViewForEntity(gameObject).returns(display);

        var footprint: Footprint2D = new Footprint2D();
        footprint.footprint = new Rectangle(5, 10, 30, 20);
        gameObject.footprint.returns(footprint);
        gameObject.worldPoint.returns(new WorldPoint2D(83, 347));
        wp.x = 83;
        wp.z = 347;

        gameWorld.addGameObject(gameObject, wp);

        var entity: WorldEntity = gameWorld.getItemAt(null);
        Assert.isNull(entity);

    }

    private function getGameObjectCount(): UInt {
        var objCount: Int = 0;
        for(i in gameWorld.gameObjects) {
            objCount++;
        }
        return objCount;
    }
}

