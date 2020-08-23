package gameentities;

import constants.EventNames;
import mocks.MockGameObject;
import world.GameObject;
import mocks.MockViewPort;
import util.MappedSubscriber;
import util.Subscriber;
import world.ViewPort;
import massive.munit.Assert;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class GameLoopViewPortTrackerTest {

    private var viewPortTracker: GameLoopViewPortTracker;
    private var viewPort: MockViewPort;
    private var subscriber: MappedSubscriber;
    private var gameObject: MockGameObject;

    @Before
    public function setup():Void {
        viewPort = mock(MockViewPort);
        subscriber = new MappedSubscriber();
        subscriber.init();
        gameObject = mock(MockGameObject);

        viewPort.get_width().returns(1000);
        viewPort.get_height().returns(800);

        viewPortTracker = new GameLoopViewPortTracker();
        viewPortTracker.subscriber = subscriber;
        viewPortTracker.viewPort = viewPort;
        viewPortTracker.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldSubscribeToGameLoopIfSubscribedToGameObject(): Void {
        gameObject.get_x().returns(300);
        gameObject.get_z().returns(225);

        viewPortTracker.trackToGameObject(gameObject);
        subscriber.notify(EventNames.ENTER_GAME_LOOP, []);

        viewPort.set_x(-500 + 300).verify();
        viewPort.set_y(-400 + 225).verify();
    }

    @Test
    public function shouldUnsubscribeFromGameLoopIfGameObjectIsUnsubscribed(): Void {
        gameObject.get_x().returns(300);
        gameObject.get_z().returns(225);

        viewPortTracker.trackToGameObject(gameObject);
        subscriber.notify(EventNames.ENTER_GAME_LOOP, []);

        viewPortTracker.untrackFromGameObject();
        subscriber.notify(EventNames.ENTER_GAME_LOOP, []);

        viewPort.set_x(-500 + 300).verify();
        viewPort.set_y(-400 + 225).verify();
    }

    @Test
    public function shouldNotSubscribeIfGameObjectIsNull(): Void {
        viewPortTracker.trackToGameObject(null);
        subscriber.notify(EventNames.ENTER_GAME_LOOP, []);
        viewPort.set_x(cast any).verify(0);
        viewPort.set_y(cast any).verify(0);
    }

    @Test
    public function shouldDispose(): Void {
        subscriber = mock(MappedSubscriber);
        viewPortTracker.subscriber = subscriber;

        viewPortTracker.dispose();

        subscriber.unsubscribe(EventNames.ENTER_GAME_LOOP, cast any).verify();

        Assert.isNull(viewPortTracker.viewPort);
        Assert.isNull(viewPortTracker.subscriber);
        Assert.isNull(viewPortTracker.gameObject);
    }
}