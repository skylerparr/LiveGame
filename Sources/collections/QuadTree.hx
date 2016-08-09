package collections;
import collections.QuadTree;
import geom.Point;
import geom.Rectangle;
class QuadTree implements QuadTreeNode {
    public var tree: Array<QuadTreeNode>;

    @:isVar
    public var area(get, null):Rectangle;

    private var countToSplit: UInt;
    private var maxDepth: UInt;

    public function get_area():Rectangle {
        return area;
    }

    public function new(totalArea: Rectangle, countToSplit: UInt = 5, maxDepth: UInt = 10) {
        this.area = totalArea.clone();
        tree = [];
        this.countToSplit = countToSplit;
        this.maxDepth = maxDepth;
    }

    public function add(area: Rectangle, data: Dynamic): Dynamic {
        var node: QuadTreeNode = new QuadTreeNodeLeaf(area, data);
        tree.push(node);
        if(tree.length == countToSplit && maxDepth > 0) {
            var tmpTree: Array<QuadTreeNode> = tree;
            splitTree();
            for(leaf in tmpTree) {
                insertIntoTrees(cast leaf);
            }
        }
        return data;
    }

    private inline function insertIntoTrees(leaf: QuadTreeNodeLeaf): Void {
        for(branch in tree) {
            if(leaf.area.intersects(branch.area)) {
                cast(branch, QuadTree).add(leaf.area, leaf.data);
            }
        }
    }

    private inline function splitTree(): Void {
        tree = [];
        var halfWidth: Float = area.width * 0.5;
        var halfHeight: Float = area.height * 0.5;
        tree.push(createNewTree(area.x, area.y, halfWidth, halfHeight));
        tree.push(createNewTree(area.x + halfWidth, area.y, halfWidth, halfHeight));
        tree.push(createNewTree(area.x, area.y + halfHeight, halfWidth, halfHeight));
        tree.push(createNewTree(area.x + halfWidth, area.y + halfHeight, halfWidth, halfHeight));
    }

    private inline function createNewTree(x: Float, y: Float, width: Float, height: Float): QuadTree {
        var newArea: Rectangle = new Rectangle(x, y, width, height);
        var retVal: QuadTree = new QuadTree(newArea, countToSplit, maxDepth - 1);
        return retVal;
    }

    public function removeItemAtPoint(point: Point, data: Dynamic): Dynamic {
//        var retVal: Array<Dynamic> = [];
//        var nodes: Array<QuadTreeNode> = getNodesAtPoint(point);
//        for(node in nodes) {
//            if(cast(node, QuadTreeNodeLeaf).data == data) {
//                tree.remove(node);
//                return data;
//            }
//        }
        return null;
    }

    public function getItemsAtPoint(point: Point): Array<Dynamic> {
        var retVal: Array<Dynamic> = [];
        var accumulator: UniqueCollection<QuadTreeNode> = new UniqueCollection<QuadTreeNode>();
        var nodes: UniqueCollection<QuadTreeNode> = getNodesAtPoint(tree, point.x, point.y, accumulator);
        for(node in nodes) {
            retVal.push(cast(node, QuadTreeNodeLeaf).data);
        }
        return retVal;
    }

    private inline function getNodesAtPoint(quadTreeNodes: Array<QuadTreeNode>, x: Float, y: Float, accumulator: UniqueCollection<QuadTreeNode>): UniqueCollection<QuadTreeNode> {
        var secondNode: QuadTreeNode = quadTreeNodes[1];
        if(Std.is(secondNode, QuadTree)) {
            var secondNodeArea: Rectangle = secondNode.area;
            var fourthNodeArea: Rectangle = quadTreeNodes[3].area;
            if(x < secondNodeArea.x) {
                if(y < fourthNodeArea.y) {
                    //quadrant 1
                    getNodesAtPoint(cast(quadTreeNodes[0], QuadTree).tree, x, y, accumulator);
                } else {
                    //quadrant 4
                    getNodesAtPoint(cast(quadTreeNodes[3], QuadTree).tree, x, y, accumulator);
                }
            } else {
                if(y < fourthNodeArea.y) {
                    //quadrant 2
                    getNodesAtPoint(cast(quadTreeNodes[1], QuadTree).tree, x, y, accumulator);
                } else {
                    //quadrant 3
                    getNodesAtPoint(cast(quadTreeNodes[2], QuadTree).tree, x, y, accumulator);
                }
            }
        } else {
            getLeavesAtPoint(quadTreeNodes, x, y, accumulator);
        }
        return accumulator;
    }

    private inline function getLeavesAtPoint(quadTreeNodes: Array<QuadTreeNode>, x: Float, y: Float, accumulator: UniqueCollection<QuadTreeNode>):UniqueCollection<QuadTreeNode> {
        for(item in quadTreeNodes) {
            var rect: Rectangle = item.area;
            if(rect.contains(x, y)) {
                accumulator.add(item);
            }
        }
        return accumulator;
    }

}
