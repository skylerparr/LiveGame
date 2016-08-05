package collections;

import collections.QuadTreeNodeLeaf;
import geom.Point;
import geom.Rectangle;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class QuadTreeTest {

    private var quadTree: QuadTree;
    private var totalArea: Rectangle;

    @Before
    public function setup():Void {
        totalArea = new Rectangle(50, 80, 800, 600);
        quadTree = new QuadTree(totalArea);
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldBeAbleToIndexASingleNode(): Void {
        var data = {};
        var rectangle: Rectangle = new Rectangle(200, 100, 20, 20);
        quadTree.add(rectangle, data);

        var items: Array<Dynamic> = quadTree.getItemsAtPoint(new Point(215, 110));
        Assert.areEqual(1, items.length);
        Assert.areEqual(data, items[0]);
    }

    @Test
    public function shouldReturnNullIfNothingFoundAtPoint(): Void {
        var data = {};
        var rectangle: Rectangle = new Rectangle(200, 100, 20, 20);
        quadTree.add(rectangle, data);

        var items: Array<Dynamic> = quadTree.getItemsAtPoint(new Point(1215, 110));
        Assert.areEqual(0, items.length);
    }

    @Test
    public function shouldGetRectForData(): Void {
        var data = {};
        var rectangle: Rectangle = new Rectangle(200, 100, 20, 20);
        quadTree.add(rectangle, data);

        var items: Array<Dynamic> = quadTree.getItemsAtPoint(new Point(215, 110));
        var itemData: Dynamic = items[0];
        var itemRect: Rectangle = quadTree.getRectForData(itemData);
        Assert.areEqual(200, itemRect.x);
        Assert.areEqual(100, itemRect.y);
        Assert.areEqual(20, itemRect.width);
        Assert.areEqual(20, itemRect.height);
    }

    @Test
    public function shouldReturnNullIfNoRectangleForData(): Void {
        var data = {};
        var rectangle: Rectangle = new Rectangle(200, 100, 20, 20);
        quadTree.add(rectangle, data);

        var itemRect: Rectangle = quadTree.getRectForData({});
        Assert.isNull(itemRect);
    }

//    @Test
//    public function shouldGetAllDataFromTree(): Void {
//        for(i in 0...50) {
//            var data = {value: i};
//            var rectangle: Rectangle = new Rectangle(200 + i, 100, 20, 20);
//            quadTree.add(rectangle, data);
//        }
//
//        var items: Array<Dynamic> = quadTree.getAllData();
//        Assert.areEqual(50, items.length);
//        var item: Dynamic = items[0];
//        Assert.areEqual(0, item.value);
//    }
//
//    @Test
//    public function shouldRemoveItem(): Void {
//        var itemToRemove: Dynamic = null;
//        for(i in 0...50) {
//            var data = {value: i};
//            var rectangle: Rectangle = new Rectangle(200 + i, 100, 20, 20);
//            quadTree.add(rectangle, data);
//            if(i == 18) {
//                itemToRemove = data;
//            }
//        }
//
//        var retVal: Dynamic = quadTree.remove(itemToRemove);
//        Assert.isNotNull(retVal);
//        Assert.areEqual(itemToRemove, retVal);
//    }
//
//    @Test
//    public function shouldReturnNullIfNoItemFoundOnRemoveItem(): Void {
//        var itemToRemove: Dynamic = null;
//        for(i in 0...50) {
//            var data = {value: i};
//            var rectangle: Rectangle = new Rectangle(200 + i, 100, 20, 20);
//            quadTree.add(rectangle, data);
//            if(i == 18) {
//                itemToRemove = data;
//            }
//        }
//        var retVal: Dynamic = quadTree.remove(itemToRemove);
//        Assert.isNotNull(retVal);
//
//        var retVal: Dynamic = quadTree.remove(itemToRemove);
//        Assert.isNull(retVal);
//    }
//
//    @Test
//    public function shouldRemoveItemAtPoint(): Void {
//        var itemToRemove: Dynamic = null;
//        for(i in 0...50) {
//            var data = {value: i};
//            var rectangle: Rectangle = new Rectangle(200 + i, 100, 20, 20);
//            quadTree.add(rectangle, data);
//            if(i == 18) {
//                itemToRemove = data;
//            }
//        }
//
//        var items: Array<Dynamic> = quadTree.getItemsAtPoint(new Point(220, 110));
//        Assert.areEqual(21, items.length);
//
//        var itemData: Dynamic = quadTree.removeItemAtPoint(new Point(220, 110), itemToRemove);
//        Assert.areEqual(itemToRemove, itemData);
//
//        itemData = quadTree.removeItemAtPoint(new Point(220, 110), itemToRemove);
//        Assert.isNull(itemData);
//    }

    @Test
    public function shouldSplitIntoFourTreesIfHitsThreshold(): Void {
        var itemToRemove: Dynamic = null;
        var data = {value: 0};
        var rectangle: Rectangle = new Rectangle(50, 100, 20, 20);
        quadTree.add(rectangle, data);

        var data = {value: 1};
        var rectangle: Rectangle = new Rectangle(550, 100, 20, 20);
        quadTree.add(rectangle, data);

        var data = {value: 2};
        var rectangle: Rectangle = new Rectangle(50, 400, 20, 20);
        quadTree.add(rectangle, data);

        var data = {value: 3};
        var rectangle: Rectangle = new Rectangle(550, 400, 20, 20);
        quadTree.add(rectangle, data);

        var data = {value: 4};
        var rectangle: Rectangle = new Rectangle(90, 100, 20, 20);
        quadTree.add(rectangle, data);

        var tree: Array<QuadTreeNode> = quadTree.tree;
        validateQuadTree(tree[0], 50, 80, 400, 300, 2);
        validateQuadTree(tree[1], 450, 80, 400, 300, 1);
        validateQuadTree(tree[2], 50, 380, 400, 300, 1);
        validateQuadTree(tree[3], 450, 380, 400, 300, 1);
    }

    private function validateQuadTree(treeNode:QuadTreeNode, x:Int, y:Int, width:Int, height:Int, leafCount: Int):Void {
        Assert.isType(treeNode, QuadTree);
        Assert.areEqual(x, treeNode.area.x);
        Assert.areEqual(y, treeNode.area.y);
        Assert.areEqual(width, treeNode.area.width);
        Assert.areEqual(height, treeNode.area.height);

        Assert.areEqual(leafCount, cast(treeNode, QuadTree).tree.length);
    }
}