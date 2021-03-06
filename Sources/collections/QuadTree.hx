package collections;
import collections.QuadTreeNodeLeaf;
import collections.QuadTree;
import collections.QuadTreeNodeLeaf;
import geom.Point;
import geom.Rectangle;
class QuadTree implements QuadTreeNode {

    public var tree: Array<QuadTreeNode>;
    public var parentNodes:Array<QuadTreeNode>;

    @:isVar
    public var area(get, null):Rectangle;

    private var countToSplit: Int;
    private var maxDepth: UInt;

    public function get_area():Rectangle {
        return area;
    }

    public function new(totalArea: Rectangle, countToSplit: UInt = 5, maxDepth: UInt = 5) {
        this.area = totalArea.clone();
        tree = [];
        this.countToSplit = countToSplit;
        this.maxDepth = maxDepth;
        this.parentNodes = [];
    }

    public function add(rect: Rectangle, data: Dynamic): Dynamic {
        var leaf: QuadTreeNodeLeaf = new QuadTreeNodeLeaf(rect, data);
        addLeaf(leaf);
        return data;
    }

    private inline function addLeafToThisTree(leaf: QuadTreeNodeLeaf): Void {
        leaf.parentNodes.push(this);
        tree.push(leaf);
    }

    public function addLeaf(leaf: QuadTreeNodeLeaf): Void {
        if(tree.length == 0) {
            addLeafToThisTree(leaf);
            return;
        }
        if(Std.is(tree[0], QuadTree)) {
            var rect: Rectangle = leaf.area;
            for(node in tree) {
                if(node.area.intersects(rect)) {
                    var quad: QuadTree = cast node;
                    quad.addLeaf(leaf);
                }
            }
            return;
        }
        addLeafToThisTree(leaf);
        if(tree.length == countToSplit && maxDepth > 0) {
            var tempTree: Array<QuadTreeNode> = tree;
            splitTree();
            for(leaf in tempTree) {
                leaf.parentNodes.remove(this);
                insertLeafIntoTree(cast leaf);
            }
        }
    }

    private inline function splitTree(): Void {
        tree = [];
        var x: Float = area.x;
        var y: Float = area.y;
        var halfWidth: Float = area.width * 0.5;
        var halfHeight: Float = area.height * 0.5;
        var depth: Int = --maxDepth;
        tree.push(createQuadTree(x, y, halfWidth, halfHeight, depth));
        tree.push(createQuadTree(x + halfWidth, y, halfWidth, halfHeight, depth));
        tree.push(createQuadTree(x, y + halfHeight, halfWidth, halfHeight, depth));
        tree.push(createQuadTree(x + halfWidth, y + halfHeight, halfWidth, halfHeight, depth));
    }

    private inline function createQuadTree(x: Float, y: Float, halfWidth: Float, halfHeight: Float, depth: Int): QuadTree {
        var quad: QuadTree = new QuadTree(new Rectangle(x, y, halfWidth, halfHeight), countToSplit, depth);
        quad.parentNodes.push(this);
        return quad;
    }

    private inline function insertLeafIntoTree(leaf: QuadTreeNodeLeaf): Void {
        for(node in tree) {
            var quad: QuadTree = cast node;
            if(quad.area.intersects(leaf.area)) {
                quad.addLeaf(leaf);
            }
        }
    }

    public function getFirstItemAtPoint(point: Point): Dynamic {
        if(Std.is(tree[0], QuadTree)) {
            var quad: QuadTree = getQuad(point);
            return quad.getFirstItemAtPoint(point);
        } else {
            var leaf: QuadTreeNodeLeaf = getFirstLeafAtPoint(point);
            if(leaf != null) {
                return leaf.data;
            } else {
                return null;
            }
        }
    }

    private inline function getQuad(point: Point): QuadTree {
        var retVal: QuadTree = null;
        var secondQuad: Rectangle = tree[1].area;
        var fourthQuad: Rectangle = tree[3].area;
        if(point.x < secondQuad.x) {
            if(point.y < fourthQuad.y) {
                retVal = cast tree[0];
            } else {
                retVal = cast tree[2];
            }
        } else {
            if(point.y < fourthQuad.y) {
                retVal = cast tree[1];
            } else {
                retVal = cast tree[3];
            }
        }
        return retVal;
    }

    private inline function getFirstLeafAtPoint(point:Point):QuadTreeNodeLeaf {
        var retVal: QuadTreeNodeLeaf = null;
        for(leafNode in tree) {
            if(leafNode.area.containsPoint(point)) {
                retVal = cast leafNode;
                break;
            }
        }
        return retVal;
    }

    public function getLeafByData(data: Dynamic): QuadTreeNodeLeaf {
        if(Std.is(tree[0], QuadTree)) {
            for(node in tree) {
                var quad: QuadTree = cast node;
                var leaf: QuadTreeNodeLeaf = quad.getLeafByData(data);
                if(leaf != null) {
                    return leaf;
                }
            }
            return null;
        } else {
            for(leaf in tree) {
                var leaf: QuadTreeNodeLeaf = cast leaf;
                if(leaf.data == data) {
                    return leaf;
                }
            }
            return null;
        }
    }

    public function getAllItemsAtPoint(point: Point): Array<Dynamic> {
        if(Std.is(tree[0], QuadTree)) {
            var quad: QuadTree = getQuad(point);
            return quad.getAllItemsAtPoint(point);
        } else {
            var retVal: Array<Dynamic> = [];
            var x: Float = point.x;
            var y: Float = point.y;
            for(node in tree) {
                var leaf: QuadTreeNodeLeaf = cast node;
                if(leaf.area.contains(x, y)) {
                    retVal.push(leaf.data);
                }
            }
            return retVal;
        }
    }

    public function remove(data:Dynamic):Bool {
        var leaf: QuadTreeNodeLeaf = getLeafByData(data);
        if(leaf != null) {
            for(node in leaf.parentNodes) {
                var quad: QuadTree = cast node;
                quad.tree.remove(leaf);
                restructureQuad(quad);
            }
            return true;
        }
        return false;
    }

    private inline function restructureQuad(quad: QuadTree): Void {
        var parent: QuadTree = cast quad.parentNodes[0];
        if(parent != null) {
            var count: Int = 0;
            for(node in parent.tree) {
                if(Std.is(node, QuadTree)) {
                    var quad: QuadTree = cast node;
                    count += quad.tree.length;
                }
            }
            if(count == parent.countToSplit - 1) {
                var tmpTree: Array<QuadTreeNode> = parent.tree;
                parent.tree = [];
                for(quad in tmpTree) {
                    var quad: QuadTree = cast quad;
                    for(node in quad.tree) {
                        var leaf: QuadTreeNodeLeaf = cast node;
                        leaf.parentNodes.remove(parent);
                        parent.addLeaf(leaf);
                    }
                }
            }
        }
    }

    #if !test
    public function debug(g: kha.graphics2.Graphics): Void {
        g.begin(false);
        g.drawRect(area.x, area.y, area.width, area.height);
        g.end();
        if(Std.is(tree[0], QuadTree)) {
            for(node in tree) {
                var quad: QuadTree = cast node;
                quad.debug(g);
            }
        } else {
            for(node in tree) {
                var leaf: QuadTreeNodeLeaf = cast node;
                var leafArea: Rectangle = leaf.area;
                var data: Dynamic = leaf.data;
                g.begin(false);
                g.color = kha.Color.fromBytes(data.r, data.g, data.b);
                g.fillRect(leafArea.x, leafArea.y, leafArea.width, leafArea.height);
                g.end();
            }
        }
    }
    #end
}
