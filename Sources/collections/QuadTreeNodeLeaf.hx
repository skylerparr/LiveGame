package collections;
import geom.Rectangle;
class QuadTreeNodeLeaf implements QuadTreeNode {

    public var area(get, null): Rectangle;
    public var data: Dynamic;

    public var parentNodes:Array<QuadTreeNode>;

    public function new(area: Rectangle = null, data: Dynamic = null) {
        this.area = area.clone();
        this.data = data;
        this.parentNodes = [];
    }

    public function get_area():Rectangle {
        return area;
    }
}
