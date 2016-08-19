package display;
interface DisplayNodeContainer extends DisplayNode {

    var numChildren(get, null): UInt;

    var mouseChildren(get, set): Bool;

    function addChild(node: DisplayNode): DisplayNode;

    function addChildAt(node: DisplayNode, index: UInt): DisplayNode;

    function getChildAt(index: UInt): DisplayNode;

    function removeChild(node: DisplayNode): DisplayNode;

    function removeChildAt(index: UInt): DisplayNode;
}
