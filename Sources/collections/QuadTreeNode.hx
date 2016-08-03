package collections;
import geom.Rectangle;
class QuadTreeNode {

    public var area: Rectangle;
    public var data: Dynamic;

    public function new(area: Rectangle = null, data: Dynamic = null) {
        this.area = area.clone();
        this.data = data;
    }
}
