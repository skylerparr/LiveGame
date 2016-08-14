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
        totalArea = new Rectangle(0, 0, 800, 600);
        quadTree = new QuadTree(totalArea);
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldBeAbleToIndexASingleNode(): Void {
        Assert.areEqual(0, quadTree.area.x);
        Assert.areEqual(0, quadTree.area.y);
        Assert.areEqual(800, quadTree.area.width);
        Assert.areEqual(600, quadTree.area.height);
        Assert.areEqual(0, quadTree.parentNodes.length);

        var data = {};
        var rectangle: Rectangle = new Rectangle(100, 110, 20, 20);
        Assert.areEqual(data, quadTree.add(rectangle, data));

        Assert.areEqual(data, cast(quadTree.tree[0], QuadTreeNodeLeaf).data);
        Assert.areEqual(1, cast(quadTree.tree[0], QuadTreeNodeLeaf).parentNodes.length);
        Assert.areEqual(quadTree, cast(quadTree.tree[0], QuadTreeNodeLeaf).parentNodes[0]);
    }

    @Test
    public function shouldBeAbleToFetchSingleNodeByLocation(): Void {
        var data = {};
        var rectangle: Rectangle = new Rectangle(100, 110, 20, 20);
        quadTree.add(rectangle, data);

        var foundData: Dynamic = quadTree.getFirstItemAtPoint(new Point(100, 110));
        Assert.isNotNull(foundData);
        Assert.areEqual(data, foundData);
    }

    @Test
    public function shouldReturnNullIfItemNotFoundAtPoint(): Void {
        var data = {};
        var rectangle: Rectangle = new Rectangle(100, 110, 20, 20);
        quadTree.add(rectangle, data);
        var foundData: Dynamic = quadTree.getFirstItemAtPoint(new Point(200, 110));
        Assert.isNull(foundData);
    }

    @Test
    public function shouldGetLeafByData(): Void {
        var data = {value: 1};
        var rectangle: Rectangle = new Rectangle(100, 110, 20, 20);
        quadTree.add(rectangle, data);

        var data1 = {value: 2};
        var rectangle: Rectangle = new Rectangle(430, 110, 20, 20);
        quadTree.add(rectangle, data1);

        var data2 = {value: 3};
        var rectangle: Rectangle = new Rectangle(130, 310, 20, 20);
        quadTree.add(rectangle, data2);

        var data3 = {value: 4};
        var rectangle: Rectangle = new Rectangle(430, 310, 20, 20);
        quadTree.add(rectangle, data3);

        var leaf: QuadTreeNodeLeaf = quadTree.getLeafByData(data2);
        Assert.isNotNull(leaf);
        Assert.areEqual(data2, leaf.data);
        Assert.areEqual(quadTree, leaf.parentNodes[0]);

        var leaf: QuadTreeNodeLeaf = quadTree.getLeafByData({});
        Assert.isNull(leaf);
    }

    @Test
    public function shouldSplitIntoQuadsWhenHitsThreshold(): Void {
        var data = {value: 1};
        var rectangle: Rectangle = new Rectangle(100, 110, 20, 20);
        quadTree.add(rectangle, data);

        var data1 = {value: 2};
        var rectangle: Rectangle = new Rectangle(430, 110, 20, 20);
        quadTree.add(rectangle, data1);

        var data2 = {value: 3};
        var rectangle: Rectangle = new Rectangle(130, 310, 20, 20);
        quadTree.add(rectangle, data2);

        var data3 = {value: 4};
        var rectangle: Rectangle = new Rectangle(430, 310, 20, 20);
        quadTree.add(rectangle, data3);

        Assert.areEqual(4, quadTree.tree.length);
        Assert.areEqual(data, quadTree.getFirstItemAtPoint(new Point(100, 110)));
        Assert.areEqual(data1, quadTree.getFirstItemAtPoint(new Point(430, 111)));
        Assert.areEqual(data2, quadTree.getFirstItemAtPoint(new Point(140, 311)));
        Assert.areEqual(data3, quadTree.getFirstItemAtPoint(new Point(430, 310)));

        var data4 = {value: 5};
        var rectangle: Rectangle = new Rectangle(40, 110, 20, 20);
        quadTree.add(rectangle, data4);

        Assert.isType(quadTree.tree[0], QuadTree);
        assertQuadTree(cast quadTree.tree[0], 0, 0, 400, 300);
        assertQuadTree(cast quadTree.tree[1], 400, 0, 400, 300);
        assertQuadTree(cast quadTree.tree[2], 0, 300, 400, 300);
        assertQuadTree(cast quadTree.tree[3], 400, 300, 400, 300);
    }

    @Test
    public function shouldTraverseTheTreeToGetFirstItemAtPoint(): Void {
        var data = {value: 1};
        var rectangle: Rectangle = new Rectangle(100, 110, 20, 20);
        quadTree.add(rectangle, data);

        var data1 = {value: 2};
        var rectangle: Rectangle = new Rectangle(430, 110, 20, 20);
        quadTree.add(rectangle, data1);

        var data2 = {value: 3};
        var rectangle: Rectangle = new Rectangle(130, 310, 20, 20);
        quadTree.add(rectangle, data2);

        var data3 = {value: 4};
        var rectangle: Rectangle = new Rectangle(430, 310, 20, 20);
        quadTree.add(rectangle, data3);

        var data4 = {value: 5};
        var rectangle: Rectangle = new Rectangle(40, 110, 20, 20);
        quadTree.add(rectangle, data4);

        Assert.areEqual(data, quadTree.getFirstItemAtPoint(new Point(100, 110)));
        Assert.areEqual(data1, quadTree.getFirstItemAtPoint(new Point(430, 111)));
        Assert.areEqual(data2, quadTree.getFirstItemAtPoint(new Point(140, 311)));
        Assert.areEqual(data3, quadTree.getFirstItemAtPoint(new Point(430, 310)));
        Assert.areEqual(data4, quadTree.getFirstItemAtPoint(new Point(40, 110)));
    }

    @Test
    public function shouldTraverseTheTreeToGetNodeByData(): Void {
        var data = {value: 1};
        var rectangle: Rectangle = new Rectangle(100, 110, 20, 20);
        quadTree.add(rectangle, data);

        var data1 = {value: 2};
        var rectangle: Rectangle = new Rectangle(430, 110, 20, 20);
        quadTree.add(rectangle, data1);

        var data2 = {value: 3};
        var rectangle: Rectangle = new Rectangle(130, 310, 20, 20);
        quadTree.add(rectangle, data2);

        var data3 = {value: 4};
        var rectangle: Rectangle = new Rectangle(430, 310, 20, 20);
        quadTree.add(rectangle, data3);

        var data4 = {value: 5};
        var rectangle: Rectangle = new Rectangle(40, 110, 20, 20);
        quadTree.add(rectangle, data4);

        Assert.areEqual(data, quadTree.getLeafByData(data).data);
        Assert.areEqual(data1, quadTree.getLeafByData(data1).data);
        Assert.areEqual(data2, quadTree.getLeafByData(data2).data);
        Assert.areEqual(data3, quadTree.getLeafByData(data3).data);
        Assert.areEqual(data4, quadTree.getLeafByData(data4).data);
        Assert.isNull(quadTree.getLeafByData({}));
    }

    @Test
    public function shouldAssignCorrectParentNode(): Void {
        var data = {value: 1};
        var rectangle: Rectangle = new Rectangle(100, 110, 20, 20);
        quadTree.add(rectangle, data);

        var data1 = {value: 2};
        var rectangle: Rectangle = new Rectangle(430, 110, 20, 20);
        quadTree.add(rectangle, data1);

        var data2 = {value: 3};
        var rectangle: Rectangle = new Rectangle(130, 310, 20, 20);
        quadTree.add(rectangle, data2);

        var data3 = {value: 4};
        var rectangle: Rectangle = new Rectangle(430, 310, 20, 20);
        quadTree.add(rectangle, data3);

        var data4 = {value: 5};
        var rectangle: Rectangle = new Rectangle(40, 110, 20, 20);
        quadTree.add(rectangle, data4);

        Assert.areEqual(quadTree, quadTree.tree[0].parentNodes[0]);
        Assert.areEqual(quadTree, quadTree.tree[1].parentNodes[0]);
        Assert.areEqual(quadTree, quadTree.tree[2].parentNodes[0]);
        Assert.areEqual(quadTree, quadTree.tree[3].parentNodes[0]);

        Assert.areEqual(1, quadTree.getLeafByData(data).parentNodes.length);
        Assert.areEqual(quadTree.tree[0], quadTree.getLeafByData(data).parentNodes[0]);
        Assert.areEqual(1, quadTree.getLeafByData(data1).parentNodes.length);
        Assert.areEqual(quadTree.tree[1], quadTree.getLeafByData(data1).parentNodes[0]);
        Assert.areEqual(1, quadTree.getLeafByData(data2).parentNodes.length);
        Assert.areEqual(quadTree.tree[2], quadTree.getLeafByData(data2).parentNodes[0]);
        Assert.areEqual(1, quadTree.getLeafByData(data3).parentNodes.length);
        Assert.areEqual(quadTree.tree[3], quadTree.getLeafByData(data3).parentNodes[0]);
        Assert.areEqual(1, quadTree.getLeafByData(data4).parentNodes.length);
        Assert.areEqual(quadTree.tree[0], quadTree.getLeafByData(data4).parentNodes[0]);
    }

    @Test
    public function shouldAddLeafToCorrectBranchAfterSplit(): Void {
        var data = {value: 1};
        var rectangle: Rectangle = new Rectangle(100, 110, 20, 20);
        quadTree.add(rectangle, data);

        var data1 = {value: 2};
        var rectangle: Rectangle = new Rectangle(430, 110, 20, 20);
        quadTree.add(rectangle, data1);

        var data2 = {value: 3};
        var rectangle: Rectangle = new Rectangle(130, 310, 20, 20);
        quadTree.add(rectangle, data2);

        var data3 = {value: 4};
        var rectangle: Rectangle = new Rectangle(430, 310, 20, 20);
        quadTree.add(rectangle, data3);

        var data4 = {value: 5};
        var rectangle: Rectangle = new Rectangle(40, 110, 20, 20);
        quadTree.add(rectangle, data4);

        var data5 = {value: 6};
        var rectangle: Rectangle = new Rectangle(70, 110, 20, 20);
        quadTree.add(rectangle, data5);

        Assert.areEqual(4, quadTree.tree.length);
        Assert.areEqual(1, quadTree.getLeafByData(data5).parentNodes.length);
        Assert.areEqual(quadTree.tree[0], quadTree.getLeafByData(data5).parentNodes[0]);
    }

    @Test
    public function shouldNotExceedMaxDepth(): Void {
        var first: Dynamic = null;
        for(i in 0...50) {
            var data = {value: i};
            if(first == null) {
                first = data;
            }
            var rectangle: Rectangle = new Rectangle(i, 110, 20, 20);
            quadTree.add(rectangle, data);
        }
        var leaf: QuadTreeNodeLeaf = quadTree.getLeafByData(first);
        Assert.areEqual(2, leaf.parentNodes.length);
        var parentCount: Int = 0;
        var parent: QuadTreeNode = leaf.parentNodes[0];
        while(parent.parentNodes.length != 0) {
            Assert.areEqual(1, parent.parentNodes.length);
            parent = parent.parentNodes[0];
            parentCount++;
        }
        Assert.areEqual(5, parentCount);
    }

    @Test
    public function shouldHaveMultipleParentsIfStradlesBorder(): Void {
        var data = {value: 1};
        var rectangle: Rectangle = new Rectangle(100, 110, 20, 20);
        quadTree.add(rectangle, data);

        var data1 = {value: 2};
        var rectangle: Rectangle = new Rectangle(430, 110, 20, 20);
        quadTree.add(rectangle, data1);

        var data2 = {value: 3};
        var rectangle: Rectangle = new Rectangle(130, 310, 20, 20);
        quadTree.add(rectangle, data2);

        var data3 = {value: 4};
        var rectangle: Rectangle = new Rectangle(430, 310, 20, 20);
        quadTree.add(rectangle, data3);

        var data4 = {value: 5};
        var rectangle: Rectangle = new Rectangle(390, 110, 20, 20);
        quadTree.add(rectangle, data4);

        var node: QuadTreeNodeLeaf = quadTree.getLeafByData(data4);
        Assert.areEqual(2, node.parentNodes.length);
    }

    @Test
    public function shouldBeInAllParentsIfCrossesAllBorders(): Void {
        for(i in 0...50) {
            var data = {value: i};
            var rectangle: Rectangle = new Rectangle(i, 110, 20, 20);
            quadTree.add(rectangle, data);
        }
        var data = {value: "huge"};
        var rectangle: Rectangle = new Rectangle(0, 0, 799, 599);
        quadTree.add(rectangle, data);

        var node: QuadTreeNodeLeaf = quadTree.getLeafByData(data);
        Assert.areEqual(13, node.parentNodes.length);
    }

    private function assertQuadTree(tree:QuadTree, x:Float, y:Float, w:Float, h:Float):Void {
        Assert.areEqual(x, tree.area.x);
        Assert.areEqual(y, tree.area.y);
        Assert.areEqual(w, tree.area.width);
        Assert.areEqual(h, tree.area.height);
    }

}