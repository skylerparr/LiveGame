package display.two;

import display.DisplayNode;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class TwoDimDisplayNodeContainerTest {

    var container: TwoDimDisplayNodeContainer;
    var node: TwoDimDisplayNode;

    @Before
    public function setup():Void {
        container = new TwoDimDisplayNodeContainer();
        container.init();

        node = new TwoDimDisplayNode();
        node.init();
    }

    @After
    public function tearDown():Void {
        container = null;
    }

    @Test
    public function shouldAddChildNodeToTheContainer(): Void {
        var retNode: DisplayNode = container.addChild(node);

        Assert.areEqual(node, retNode);
        Assert.areEqual(container, node.parent);

        Assert.areEqual(container.children[0], node);
        Assert.areEqual(container.numChildren, 1);
    }

    @Test
    public function shouldRemoveChildFromContainer(): Void {
        container.addChild(node);
        var retNode: DisplayNode = container.removeChild(node);

        Assert.areEqual(node, retNode);
        Assert.isNull(node.parent);
        Assert.areEqual(0, container.numChildren);
    }

    @Test
    public function shouldGetChildAtIndex(): Void {
        container.addChild(node);

        var node2 = new TwoDimDisplayNode();
        node2.init();

        container.addChild(node2);

        Assert.areEqual(node, container.getChildAt(0));
        Assert.areEqual(node2, container.getChildAt(1));
    }

    @Test
    public function shouldReturnNullIfChildDoesNotExistAtIndex(): Void {
        container.addChild(node);
        Assert.isNull(container.getChildAt(2));
    }

    @Test
    public function shouldAddChildAtIndex(): Void {
        container.addChild(node);

        var node2 = new TwoDimDisplayNode();
        node2.init();

        container.addChildAt(node2, 1);

        Assert.areEqual(node, container.getChildAt(0));
        Assert.areEqual(node2, container.getChildAt(1));
    }

    @Test
    public function shouldAddChildAtMaxIndexIfIndexIsMoreThanNumChildren(): Void {
        container.addChild(node);

        var node2 = new TwoDimDisplayNode();
        node2.init();

        container.addChildAt(node2, 2);

        Assert.areEqual(node, container.getChildAt(0));
        Assert.areEqual(node2, container.getChildAt(1));
    }

    @Test
    public function shouldPushAllChildDownIfChildIsAddedAt0Index(): Void {
        container.addChild(node);

        var node2 = new TwoDimDisplayNode();
        node2.init();
        var node3 = new TwoDimDisplayNode();
        node3.init();

        container.addChild(node2);
        container.addChildAt(node3, 0);

        Assert.areEqual(3, container.numChildren);
        Assert.areEqual(node3, container.getChildAt(0));
        Assert.areEqual(node, container.getChildAt(1));
        Assert.areEqual(node2, container.getChildAt(2));
    }

    @Test
    public function shouldRemoveChildAtIndexAndReorder(): Void {
        container.addChild(node);

        var node2 = new TwoDimDisplayNode();
        node2.init();
        var node3 = new TwoDimDisplayNode();
        node3.init();

        container.addChild(node2);
        container.addChildAt(node3, 0);
        Assert.areEqual(3, container.numChildren);

        container.removeChildAt(0);
        Assert.areEqual(2, container.numChildren);
        Assert.isNull(node3.parent);

        Assert.areEqual(node, container.getChildAt(0));
        Assert.areEqual(node2, container.getChildAt(1));
    }

    @Test
    public function shouldBeAbleToAddAContainerToAContainer(): Void {
        var container2: TwoDimDisplayNodeContainer = new TwoDimDisplayNodeContainer();
        container2.init();

        container2.addChild(node);
        container.addChild(container2);

        Assert.areEqual(container2, container.getChildAt(0));
        Assert.areEqual(node, cast(container.getChildAt(0), DisplayNodeContainer).getChildAt(0));
        Assert.areEqual(container, container2.parent);

        Assert.areEqual(1, container2.numChildren);
        Assert.areEqual(1, container.numChildren);
    }

    @Test
    public function shouldGetAndSetMouseChildren(): Void {
        container.mouseChildren = true;
        Assert.isTrue(container.mouseChildren);
    }

    @Test
    public function shouldDisposeAllReferences(): Void {
        var retNode: DisplayNode = container.addChild(node);

        node.dispose();

        Assert.isNull(node.name);
        Assert.isNull(node.parent);
        Assert.isNull(node._private_parent);

        Assert.areEqual(0, container.children.length);

        container.dispose();

        Assert.isNull(container.children);
        Assert.isNull(container.name);
        Assert.isNull(container.parent);
        Assert.isNull(container._private_parent);
    }
}