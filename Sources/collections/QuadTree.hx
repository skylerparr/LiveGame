package collections;
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

    /**
     * very expensive, has to traverse entire tree
     */
    public function remove(data: Dynamic): Dynamic {
        var retVal: Dynamic = null;
        for(item in tree) {
            var itemData: Dynamic = cast(item, QuadTreeNodeLeaf).data;
            if(itemData == data) {
                tree.remove(item);
                return itemData;
            }
        }
        return null;
    }

    public function removeItemAtPoint(point: Point, data: Dynamic): Dynamic {
        var retVal: Array<Dynamic> = [];
        var nodes: Array<QuadTreeNode> = getNodesAtPoint(point);
        for(node in nodes) {
            if(cast(node, QuadTreeNodeLeaf).data == data) {
                tree.remove(node);
                return data;
            }
        }
        return null;
    }

    public function getItemsAtPoint(point: Point): Array<Dynamic> {
        var retVal: Array<Dynamic> = [];
        var nodes: Array<QuadTreeNode> = getNodesAtPoint(point);
        for(node in nodes) {
            retVal.push(cast(node, QuadTreeNodeLeaf).data);
        }
        return retVal;
    }

    private inline function getNodesAtPoint(point: Point): Array<QuadTreeNode> {
        var retVal: Array<QuadTreeNode> = [];
        for(item in tree) {
            var rect: Rectangle = item.area;
            if(rect.containsPoint(point)) {
                retVal.push(item);
            }
        }
        return retVal;
    }

    /**
     * very expensive, has to traverse entire tree
     */
    public function getRectForData(data: Dynamic): Rectangle {
        for(item in tree) {
            if(cast(item, QuadTreeNodeLeaf).data == data) {
                return item.area;
            }
        }
        return null;
    }

    /**
     * very expensive, has to traverse entire tree
     */
    public function getAllData(): Array<Dynamic> {
        var retVal: Array<Dynamic> = [];
        for(item in tree) {
            retVal.push(cast(item, QuadTreeNodeLeaf).data);
        }
        return retVal;
    }
}
