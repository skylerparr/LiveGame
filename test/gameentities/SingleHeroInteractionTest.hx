package gameentities;

import mocks.MockViewPort;
import util.MappedSubscriber;
import world.ViewPort;
import handler.output.UnitMoveTo;
import handler.IOHandler;
import mocks.MockStreamHandler;
import handler.StreamHandler;
import mocks.MockGameObject;
import world.GameObject;
import world.two.WorldPoint2D;
import world.WorldPoint;
import core.ObjectCreator;
import massive.munit.Assert;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class SingleHeroInteractionTest {

    private var heroInteraction: SingleHeroInteraction;
    private var objectCreator: ObjectCreator;
    private var streamHandler: MockStreamHandler;
    private var hero: MockGameObject;
    private var viewPortTracker: ViewPortTracker;

    @Before
    public function setup():Void {
        hero = mock(MockGameObject);
        hero.id.returns("42");
        viewPortTracker = mock(ViewPortTracker);
        objectCreator = mock(ObjectCreator);
        objectCreator.createInstance(WorldPoint).returns(new WorldPoint2D());
        objectCreator.createInstance(UnitMoveTo).returns(new UnitMoveTo());
        streamHandler = mock(MockStreamHandler);

        heroInteraction = new SingleHeroInteraction();
        heroInteraction.objectCreator = objectCreator;
        heroInteraction.streamHandler = streamHandler;
        heroInteraction.viewPortTracker = viewPortTracker;
        heroInteraction.init();

        heroInteraction.hero = hero;
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldGetHeroCurrentLocation(): Void {
        hero.x.returns(231);
        hero.z.returns(429);
        Assert.areEqual(231, heroInteraction.getCurrentLocation().x);
        Assert.areEqual(429, heroInteraction.getCurrentLocation().z);
    }

    @Test
    public function shouldReturnNullIfHeroIsNotAssigned(): Void {
        heroInteraction.hero = null;
        Assert.isNull(heroInteraction.getCurrentLocation());
    }

    @Test
    public function shouldPassUnitMoveToStreamHandler(): Void {
        streamHandler.send(cast any).calls(function(args): Void {
            var move: UnitMoveTo = cast args[0];
            Assert.areEqual(42, move.unitId);
            Assert.areEqual(324, move.posX);
            Assert.areEqual(532, move.posZ);
        });
        heroInteraction.moveTo(new WorldPoint2D(324, 532));
        streamHandler.send(cast instanceOf(IOHandler)).verify();
    }

    @Test
    public function shouldAssignHeroToViewPortTracker(): Void {
        viewPortTracker.trackToGameObject(hero).verify();
    }
}