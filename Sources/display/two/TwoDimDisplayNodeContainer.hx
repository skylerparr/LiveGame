package display.two;
import display.DisplayNodeContainer;

class TwoDimDisplayNodeContainer extends TwoDimInteractiveDisplay implements DisplayNodeContainer {

    public var children(get, null): Array<DisplayNode>;
    public var numChildren(get, null): UInt;

    @:isVar
    public var mouseChildren(get, set):Bool = true;

    public function new() {
        super();
    }

    public function get_children():Array<DisplayNode> {
        return children;
    }

    public function get_numChildren(): UInt {
        return children.length;
    }

    public function get_mouseChildren():Bool {
        return mouseChildren;
    }

    public function set_mouseChildren(value:Bool) {
        return this.mouseChildren = value;
    }

    override public function init():Void {
        super.init();
        children = new Array<DisplayNode>();
    }

    override public function dispose():Void {
        super.dispose();
        children = null;
    }

    public function addChild(node:DisplayNode):DisplayNode {
        cast(node, TwoDimDisplayNode)._private_parent = this;
        children.push(node);
        return node;
    }

    public function addChildAt(node:DisplayNode, index:UInt):DisplayNode {
        var numChild = numChildren;
        if(index >= numChild) {
            index = numChild;
        }
        children.insert(index, node);
        return node;
    }

    public function getChildAt(index:UInt):DisplayNode {
        return children[index];
    }

    public function removeChild(node:DisplayNode):DisplayNode {
        cast(node, TwoDimDisplayNode)._private_parent = null;
        children.remove(node);
        return node;
    }

    public function removeChildAt(index:UInt):DisplayNode {
        var child: DisplayNode = getChildAt(index);
        if(child != null) {
            removeChild(child);
        }
        return child;
    }

}
