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

    @Test
    public function shouldNotRemoveFromParentIfNotContainedInContainer(): Void {
        var container: TwoDimDisplayNodeContainer = new TwoDimDisplayNodeContainer();
        container.init();
        container.addChild(display);
        container.removeChild(display);

        display.dispose();

        Assert.areEqual(0, container.numChildren);
    }

    @Test
    public function shouldAssignProperties(): Void {
        var container: TwoDimDisplayNodeContainer = new TwoDimDisplayNodeContainer();
        container.init();
        container.addChild(display);

        display.x = 100;
        display.y = 200;
        display.z = 300;
        display.width = 400;
        display.height = 500;
        display.depth = 600;
        display.scaleX = 1;
        display.scaleY = 2;
        display.scaleZ = 3;
        display.name = "foo";
        display.mouseEnabled = false;

        Assert.areEqual(container, display.parent);
        Assert.areEqual(container, display._private_parent);
        Assert.areEqual(100, display.x);
        Assert.areEqual(200, display.y);
        Assert.areEqual(300, display.z);
        Assert.areEqual(400, display.width);
        Assert.areEqual(500, display.height);
        Assert.areEqual(600, display.depth);
        Assert.areEqual(1, display.scaleX);
        Assert.areEqual(2, display.scaleY);
        Assert.areEqual(3, display.scaleZ);
        Assert.areEqual("foo", display.name);
        Assert.areEqual(false, display.mouseEnabled);
    }

}