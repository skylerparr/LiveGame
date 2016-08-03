package world.two;

import mocks.MockDisplayNodeContainer;
import display.DisplayNode;
import display.two.TwoDimDisplayNodeContainer;
import display.DisplayNodeContainer;
import constants.EventNames;
import constants.EventNames;
import util.Subscriber;
import util.EventNotifier;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class ViewPort2DTest {

    private var viewPort: ViewPort2D;
    private var notifer: EventNotifier;
    private var subscriber: Subscriber;
    private var container: DisplayNodeContainer;

    @Before
    public function setup():Void {
        container = new TwoDimDisplayNodeContainer();
        container.init();

        viewPort = new ViewPort2D(container);
        viewPort.init();

        notifer = mock(EventNotifier);
        subscriber = mock(Subscriber);

        viewPort.notifier = notifer;
        viewPort.subscriber = subscriber;
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldNotifyWhenXIsUpdated(): Void {
        viewPort.x = 100;
        notifer.notify(EventNames.VIEW_PORT_TRANSLATED, null).verify();
    }

    @Test
    public function shouldNotifyWhenYIsUpdated(): Void {
        viewPort.y = 10;
        notifer.notify(EventNames.VIEW_PORT_TRANSLATED, null).verify();
    }

    @Test
    public function shouldUpdateDimensionWhenXOrYIsUpdate(): Void {
        viewPort.x = 100;
        viewPort.y = 10;

        Assert.areEqual(100, viewPort.dimension.x);
        Assert.areEqual(10, viewPort.dimension.y);
    }

    @Test
    public function shouldNotifyWhenViewPortWidthIsUpdate(): Void {
        viewPort.width = 100;
        notifer.notify(EventNames.VIEW_PORT_RESIZED, null).verify();
    }

    @Test
    public function shouldNotifyWhenViewPortHeightIsUpdate(): Void {
        viewPort.height = 10;
        notifer.notify(EventNames.VIEW_PORT_RESIZED, null).verify();
    }

    @Test
    public function shouldUpdateDimensionWhenWidthOrHeigtIsUpdated(): Void {
        viewPort.width = 20;
        viewPort.height = 30;

        Assert.areEqual(20, viewPort.dimension.width);
        Assert.areEqual(30, viewPort.dimension.height);
    }

    @Test
    public function shouldSubscribeToViewPortEvents(): Void {
        var resizeFunc: Void->Void = function(): Void {}
        var translateFunc: Void->Void = function(): Void {}
        viewPort.subscribeToResize(resizeFunc);
        viewPort.subscribeToTranslate(translateFunc);

        subscriber.subscribe(EventNames.VIEW_PORT_TRANSLATED, translateFunc).verify();
        subscriber.subscribe(EventNames.VIEW_PORT_RESIZED, resizeFunc).verify();
    }

    @Test
    public function shouldUnsubscribeToViewPortEvents(): Void {
        var resizeFunc: Void->Void = function(): Void {}
        var translateFunc: Void->Void = function(): Void {}
        viewPort.unsubscribeToResize(resizeFunc);
        viewPort.unsubscribeToTranslate(translateFunc);

        subscriber.unsubscribe(EventNames.VIEW_PORT_TRANSLATED, translateFunc).verify();
        subscriber.unsubscribe(EventNames.VIEW_PORT_RESIZED, resizeFunc).verify();
    }

    @Test
    public function shouldUpdateContainerXAndY(): Void {
        viewPort.x = 10;
        viewPort.y = 20;

        Assert.areEqual(-10, viewPort.container.x);
        Assert.areEqual(-20, viewPort.container.y);
    }

    @Test
    public function shouldUpdateTheScale(): Void {
        viewPort.scale = 0.4;
        Assert.areEqual(0.4, viewPort.scale);
    }

    @Test
    public function shouldUpdateZ(): Void {
        viewPort.z = 0.4;
        Assert.areEqual(0, viewPort.z);
    }

    @Test
    public function shouldTestToSeeIfItemsAreInViewableArea(): Void {
        var displayNode: DisplayNode = mock(MockDisplayNodeContainer);
        Assert.isTrue(viewPort.isInViewableRegion(displayNode));
    }

    @Test
    public function shouldDisposeAllReferences(): Void {
        viewPort.dispose();

        Assert.isNull(viewPort.subscriber);
        Assert.isNull(viewPort.dimension);
        Assert.isNull(viewPort.notifier);
        Assert.isNull(viewPort.container);
    }
}