package world.two;

import units.EntityFactory;
import mocks.MockViewPort;
import core.ObjectCreator;
import mocks.MockDisplayNodeContainer;
import mocks.MockGameObject;
import display.DisplayNodeContainer;
import constants.LayerNames;
import display.LayerManager;
import geom.Rectangle;
import display.DisplayNode;
import geom.Point;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
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
        wp.y = 32;
        var p: Point = gameWorld.worldToScreen(wp);

        Assert.areEqual(0, p.x);
        Assert.areEqual(0, p.y);
    }

    @Test
    public function shouldGiveTranslatedPointWhenViewPortIsTranslated(): Void {
        viewPort.x.returns(20);
        viewPort.y.returns(32);

        wp.x = 14;
        wp.y = 18;
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
        Assert.areEqual(0, wp.y);
    }

    @Test
    public function shouldGiveTranslatedValueIfViewPortHasMoved(): Void {
        viewPort.x.returns(10);
        viewPort.y.returns(20);

        var wp: WorldPoint = gameWorld.screenToWorld(point);

        Assert.areEqual(10, wp.x);
        Assert.areEqual(20, wp.y);
    }

    @Test
    public function shouldGiveTranslatedWorldPointIfViewPortMovedAndNotAtOrigin(): Void {
        viewPort.x.returns(10);
        viewPort.y.returns(20);

        point.x = 15;
        point.y = 26;
        var wp: WorldPoint = gameWorld.screenToWorld(point);

        Assert.areEqual(25, wp.x);
        Assert.areEqual(46, wp.y);
    }

    @Test
    public function shouldAddTheUnitToTheGameWorldAtASpecificWorldPoint(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);

        entityFactory.createViewForEntity(gameObject).returns(display);

        wp.x = 83;
        wp.y = 347;
        gameWorld.addGameObject(gameObject, wp);

        Assert.areEqual(gameObject, gameWorld.gameObjects.pop());

        gameLayer.addChild(display).verify();
        display.set_x(83).verify();
        display.set_y(347).verify();
        gameObject.set_x(83).verify();
        gameObject.set_y(347).verify();
    }

    @Test
    public function shouldMoveDisplayToDesiredLocation(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);

        entityFactory.createViewForEntity(gameObject).returns(display);

        wp.x = 83;
        wp.y = 347;
        gameWorld.addGameObject(gameObject, wp);
        wp.x = 23;
        wp.y = 47;
        gameWorld.moveItemTo(gameObject, wp);

        display.set_x(23).verify();
        display.set_y(47).verify();
        gameObject.set_x(23).verify();
        gameObject.set_y(47).verify();
    }
}

