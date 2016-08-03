package collections;
import geom.Point;
import geom.Rectangle;
class QuadTree {

    private var totalArea: Rectangle;

    private var tree: Array<QuadTreeNode>;

    public function new(totalArea: Rectangle) {
        this.totalArea = totalArea.clone();
        tree = [];
    }

    public function add(area: Rectangle, data: Dynamic): Dynamic {
        var node: QuadTreeNode = new QuadTreeNode(area, data);
        tree.push(node);
        return data;
    }

    /**
     * very expensive, has to traverse entire tree
     */
    public function remove(data: Dynamic): Dynamic {
        var retVal: Dynamic = null;
        for(item in tree) {
            var itemData: Dynamic = item.data;
            if(itemData == data) {
                tree.remove(item);
                return itemData;
            }
        }
        return null;
    }

    public function getItemsAtPoint(point: Point): Array<Dynamic> {
        var retVal: Array<Dynamic> = [];
        for(item in tree) {
            var rect: Rectangle = item.area;
            if(rect.containsPoint(point)) {
                retVal.push(item.data);
            }
        }
        return retVal;
    }

    /**
     * very expensive, has to traverse entire tree
     */
    public function getRectForData(data: Dynamic): Rectangle {
        for(item in tree) {
            if(item.data == data) {
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
            retVal.push(item.data);
        }
        return retVal;
    }
}
