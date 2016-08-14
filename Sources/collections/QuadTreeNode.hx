package collections;
import Array;
import geom.Rectangle;
interface QuadTreeNode {
    public var parentNodes: Array<QuadTreeNode>;
    public var area(get, null): Rectangle;
}
