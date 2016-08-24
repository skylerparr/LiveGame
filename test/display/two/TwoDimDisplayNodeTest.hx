package display.two;

import mocks.MockDisplayNodeContainer;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class TwoDimDisplayNodeTest {

    private var display: TwoDimDisplayNode;

    @Before
    public function setup():Void {
        display = new TwoDimDisplayNode();
        display.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldRemoveChildFromParentWhenDisposed(): Void {
        var container: TwoDimDisplayNodeContainer = new TwoDimDisplayNodeContainer();
        container.init();
        container.addChild(display);

        display.dispose();

        Assert.isNull(display.name);
        Assert.isNull(display.parent);
        Assert.isNull(display._private_parent);

        Assert.areEqual(0, container.numChildren);
    }

    public function shouldNotRemoveFromParentIfNotContainedInContainer(): Void {
        var container: TwoDimDisplayNodeContainer = new TwoDimDisplayNodeContainer();
        container.init();
        container.addChild(display);
        container.removeChild(display);

        display.dispose();

        Assert.areEqual(0, container.numChildren);
    }
}