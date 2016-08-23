package collections;

import geom.Rectangle;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class QuadTreeNodeLeafTest {

    @Before
    public function setup():Void {
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldCreateANewRectangleOnCreation(): Void {
        var data = {};
        var rect: Rectangle = new Rectangle(1,2,3,4);
        var treeNode: QuadTreeNodeLeaf = new QuadTreeNodeLeaf(rect, data);

        Assert.areEqual(data, treeNode.data);
        Assert.areNotEqual(rect, treeNode.area);
        Assert.areEqual(1, treeNode.area.x);
        Assert.areEqual(2, treeNode.area.y);
        Assert.areEqual(3, treeNode.area.width);
        Assert.areEqual(4, treeNode.area.height);
    }
}