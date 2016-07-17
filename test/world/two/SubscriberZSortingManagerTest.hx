package world.two;

import geom.Rectangle;
import mocks.MockGameWorldDisplayObject;
import display.two.TwoDimDisplayNode;
import display.two.TwoDimDisplayNodeContainer;
import display.DisplayNodeContainer;
import mocks.MockDisplayNodeContainer;
import display.DisplayNode;
import mocks.MockGameWorld;
import util.MappedSubscriber;
import massive.munit.Assert;

import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;
class SubscriberZSortingManagerTest {

    private var sortingManager: SubscriberZSortingManager;
    private var subscriber: MappedSubscriber;
    private var gameWorld: MockGameWorld;

    @Before
    public function setup():Void {
        gameWorld = mock(MockGameWorld);
        subscriber = new MappedSubscriber();
        subscriber.init();

        sortingManager = new SubscriberZSortingManager();
        sortingManager.gameWorld = gameWorld;
        sortingManager.subscriber = subscriber;
        sortingManager.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldSubscribeToSpecifiedEvent(): Void {
        subscriber = mock(MappedSubscriber);
        sortingManager.subscriber = subscriber;
        sortingManager.updateEvent = "myEvent";

        subscriber.subscribe("myEvent", cast isNotNull).verify();
    }

    @Test
    public function shouldUnsubscribeIfNullIsPassedToUpdateEvent(): Void {
        subscriber = mock(MappedSubscriber);
        sortingManager.subscriber = subscriber;
        sortingManager.updateEvent = "myEvent";

        sortingManager.updateEvent = null;

        subscriber.unsubscribe("myEvent", cast isNotNull).verify();
    }

    @Test
    public function shouldSortVisibleObjectsOnGameWorldDisplayContainer(): Void {
        var container: TwoDimDisplayNodeContainer = new TwoDimDisplayNodeContainer();
        container.init();

        var entityA: DisplayWorldEntity = createDisplay(40, 80, 0, 40, 20, 20);
        var entityB: DisplayWorldEntity = createDisplay(40, 70, 0, 40, 20, 20);
        container.addChild(entityA.display);
        container.addChild(entityB.display);

        gameWorld.get_displayContainer().returns(container);

        gameWorld.getWorldEntityByDisplay(entityA.display).returns(entityA.worldEntity);
        gameWorld.getWorldEntityByDisplay(entityB.display).returns(entityB.worldEntity);
        gameWorld.getDisplayByGameObject(entityA.worldEntity).returns(entityA.display);
        gameWorld.getDisplayByGameObject(entityB.worldEntity).returns(entityB.display);

        sortingManager.onUpdate();

        var children: Array<DisplayNode> = container.children;
        Assert.areEqual(entityB.display, children[0]);
        Assert.areEqual(entityA.display, children[1]);
    }

    @IgnoreCover
    private function createDisplay(posX:Float, posY:Float, x: Float, y: Float, w: Float, h: Float):DisplayWorldEntity {
        var display: TwoDimDisplayNode = new TwoDimDisplayNode();
        display.init();
        display.x = posX;
        display.y = posY;

        var worldEntity: MockGameWorldDisplayObject = mock(MockGameWorldDisplayObject);
        worldEntity.get_x().returns(posX);
        worldEntity.get_z().returns(posY);
        var footprint: Footprint = new Footprint2D();
        footprint.footprint = new Rectangle(x, y, w, h);
        worldEntity.get_footprint().returns(footprint);

        return {display: display, worldEntity: worldEntity};
    }
}

@IgnoreCover
typedef DisplayWorldEntity = {
    display: DisplayNode,
    worldEntity: WorldEntity
}