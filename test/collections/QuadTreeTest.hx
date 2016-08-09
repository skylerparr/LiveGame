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
    public function shouldReturnEmptyArrayIfNothingFoundAtPoint(): Void {
        var data = {};
        var rectangle: Rectangle = new Rectangle(200, 100, 20, 20);
        quadTree.add(rectangle, data);

        var items: Array<Dynamic> = quadTree.getItemsAtPoint(new Point(1215, 110));
        Assert.areEqual(0, items.length);
    }

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
        var data = {value: 0};
        var rectangle: Rectangle = new Rectangle(50, 100, 20, 20);
        quadTree.add(rectangle, data);

        data = {value: 1};
        rectangle = new Rectangle(550, 100, 20, 20);
        quadTree.add(rectangle, data);

        data = {value: 2};
        rectangle = new Rectangle(50, 400, 20, 20);
        quadTree.add(rectangle, data);

        data = {value: 3};
        rectangle = new Rectangle(550, 400, 20, 20);
        quadTree.add(rectangle, data);

        data = {value: 4};
        rectangle = new Rectangle(90, 100, 20, 20);
        quadTree.add(rectangle, data);

        var tree: Array<QuadTreeNode> = quadTree.tree;
        validateQuadTree(tree[0], 50, 80, 400, 300, 2);
        validateQuadTree(tree[1], 450, 80, 400, 300, 1);
        validateQuadTree(tree[2], 50, 380, 400, 300, 1);
        validateQuadTree(tree[3], 450, 380, 400, 300, 1);
    }

    @Test
    public function shouldIncludeItemsThatStradleQuadTreeBorders(): Void {
        var data = {value: 0};
        var rectangle: Rectangle = new Rectangle(445, 100, 20, 20);
        quadTree.add(rectangle, data);

        data = {value: 1};
        rectangle = new Rectangle(445, 110, 20, 20);
        quadTree.add(rectangle, data);

        data = {value: 2};
        rectangle = new Rectangle(445, 120, 20, 20);
        quadTree.add(rectangle, data);

        data = {value: 3};
        rectangle = new Rectangle(445, 130, 20, 20);
        quadTree.add(rectangle, data);

        data = {value: 4};
        rectangle = new Rectangle(445, 140, 20, 20);
        quadTree.add(rectangle, data);

        var tree: Array<QuadTreeNode> = quadTree.tree;
        Assert.isType(tree[0], QuadTree);
        var tree: Array<QuadTreeNode> = cast(tree[0], QuadTree).tree;
        Assert.isType(tree[1], QuadTree);
        validateQuadTree(tree[0], 50, 80, 200, 150, 0);
        validateQuadTree(tree[1], 250, 80, 200, 150, 4);
        validateQuadTree(tree[2], 50, 230, 200, 150, 0);
        validateQuadTree(tree[3], 250, 230, 200, 150, 0);
        var tree: Array<QuadTreeNode> = cast(tree[1], QuadTree).tree;
        Assert.isType(tree[1], QuadTree);
        validateQuadTree(tree[0], 250, 80, 100, 75, 0);
        validateQuadTree(tree[1], 350, 80, 100, 75, 4);
        validateQuadTree(tree[2], 250, 155, 100, 75, 0);
        validateQuadTree(tree[3], 350, 155, 100, 75, 1);

        Assert.isType(tree[3], QuadTree);
        var singleLeafTree: Array<QuadTreeNode> = cast(tree[3], QuadTree).tree;
        Assert.areEqual(4, cast(singleLeafTree[0], QuadTreeNodeLeaf).data.value);

        var tree: Array<QuadTreeNode> = cast(tree[1], QuadTree).tree;
        Assert.isType(tree[0], QuadTree);
        validateQuadTree(tree[0], 350, 80, 50, 37.5, 0);
        validateQuadTree(tree[1], 400, 80, 50, 37.5, 2);
        validateQuadTree(tree[2], 350, 117.5, 50, 37.5, 0);
        validateQuadTree(tree[3], 400, 117.5, 50, 37.5, 4);

        var singleLeafTree: Array<QuadTreeNode> = cast(tree[1], QuadTree).tree;
        Assert.areEqual(0, cast(singleLeafTree[0], QuadTreeNodeLeaf).data.value);
        Assert.areEqual(1, cast(singleLeafTree[1], QuadTreeNodeLeaf).data.value);

        Assert.isType(tree[3], QuadTree);

        var tree: Array<QuadTreeNode> = cast(tree[3], QuadTree).tree;
        validateQuadTree(tree[0], 400, 117.5, 25, 18.75, 0);
        validateQuadTree(tree[1], 425, 117.5, 25, 18.75, 4);
        validateQuadTree(tree[2], 400, 136.25, 25, 18.75, 0);
        validateQuadTree(tree[3], 425, 136.25, 25, 18.75, 3);

        var singleLeafTree: Array<QuadTreeNode> = cast(tree[3], QuadTree).tree;
        Assert.areEqual(2, cast(singleLeafTree[0], QuadTreeNodeLeaf).data.value);
        Assert.areEqual(3, cast(singleLeafTree[1], QuadTreeNodeLeaf).data.value);
        Assert.areEqual(4, cast(singleLeafTree[2], QuadTreeNodeLeaf).data.value);

        Assert.isType(tree[1], QuadTree);
        var tree: Array<QuadTreeNode> = cast(tree[1], QuadTree).tree;
        Assert.areEqual(0, cast(tree[0], QuadTreeNodeLeaf).data.value);
        Assert.areEqual(1, cast(tree[1], QuadTreeNodeLeaf).data.value);
        Assert.areEqual(2, cast(tree[2], QuadTreeNodeLeaf).data.value);
        Assert.areEqual(3, cast(tree[3], QuadTreeNodeLeaf).data.value);
    }

    @Test
    public function shouldGetItemsAtPoint(): Void {
        var data = {value: 0};
        var rectangle: Rectangle = new Rectangle(445, 100, 20, 20);
        quadTree.add(rectangle, data);

        data = {value: 1};
        rectangle = new Rectangle(445, 110, 20, 20);
        quadTree.add(rectangle, data);

        data = {value: 2};
        rectangle = new Rectangle(445, 120, 20, 20);
        quadTree.add(rectangle, data);

        data = {value: 3};
        rectangle = new Rectangle(445, 130, 20, 20);
        quadTree.add(rectangle, data);

        data = {value: 4};
        rectangle = new Rectangle(445, 140, 20, 20);
        quadTree.add(rectangle, data);

        var nodes: Array<Dynamic> = quadTree.getItemsAtPoint(new Point(450, 110));
        Assert.areEqual(2, nodes.length);
        Assert.areEqual(0, nodes[0].value);
        Assert.areEqual(1, nodes[1].value);

        var nodes: Array<Dynamic> = quadTree.getItemsAtPoint(new Point(51, 110));
        Assert.areEqual(0, nodes.length);

        var nodes: Array<Dynamic> = quadTree.getItemsAtPoint(new Point(51, 510));
        Assert.areEqual(0, nodes.length);

        var nodes: Array<Dynamic> = quadTree.getItemsAtPoint(new Point(451, 510));
        Assert.areEqual(0, nodes.length);
    }

    private function validateQuadTree(treeNode:QuadTreeNode, x:Float, y:Float, width:Float, height:Float, leafCount: Int):Void {
        Assert.isType(treeNode, QuadTree);
        Assert.areEqual(x, treeNode.area.x);
        Assert.areEqual(y, treeNode.area.y);
        Assert.areEqual(width, treeNode.area.width);
        Assert.areEqual(height, treeNode.area.height);

        Assert.areEqual(leafCount, cast(treeNode, QuadTree).tree.length);
    }
}