package mocks;

import input.PointerEvent;
import input.PointerEventType;
import display.DisplayNode;
import display.DisplayNodeContainer;
class MockDisplayNodeContainer implements DisplayNodeContainer {

    @:isVar public var parent(get, set): DisplayNodeContainer;

    @:isVar public var depth(get, set): Float;

    @:isVar public var scaleX(get, set): Float;

    @:isVar public var scaleY(get, set): Float;

    @:isVar public var scaleZ(get, set): Float;

    @:isVar public var numChildren(get, set): UInt;

    @:isVar public var mouseChildren(get, set): Bool;

    @:isVar public var mouseEnabled(get, set): Bool;

    @:isVar public var x(get, set): Float;

    @:isVar public var y(get, set): Float;

    @:isVar public var z(get, set): Float;

    @:isVar public var width(get, set): Float;

    @:isVar public var height(get, set): Float;

    @:isVar public var name(get, set): String;

    public function set_parent(value:DisplayNodeContainer) {
        return this.parent = value;
    }

    public function get_parent():DisplayNodeContainer {
        return parent;
    }

    public function set_depth(value:Float) {
        return this.depth = value;
    }

    public function get_depth():Float {
        return depth;
    }

    public function get_scaleX():Float {
        return scaleX;
    }

    public function set_scaleX(value:Float) {
        return this.scaleX = value;
    }

    public function set_scaleY(value:Float) {
        return this.scaleY = value;
    }

    public function get_scaleY():Float {
        return scaleY;
    }

    public function set_scaleZ(value:Float) {
        return this.scaleZ = value;
    }

    public function get_scaleZ():Float {
        return scaleZ;
    }

    public function set_numChildren(value:UInt) {
        return this.numChildren = value;
    }

    public function get_numChildren():UInt {
        return numChildren;
    }

    public function get_mouseChildren():Bool {
        return mouseChildren;
    }

    public function set_mouseChildren(value:Bool) {
        return this.mouseChildren = value;
    }

    public function get_mouseEnabled():Bool {
        return mouseEnabled;
    }

    public function set_mouseEnabled(value:Bool) {
        return this.mouseEnabled = value;
    }

    public function get_x():Float {
        return x;
    }

    public function set_x(value:Float) {
        return this.x = value;
    }

    public function set_y(value:Float) {
        return this.y = value;
    }

    public function get_y():Float {
        return y;
    }

    public function set_z(value:Float) {
        return this.z = value;
    }

    public function get_z():Float {
        return z;
    }

    public function get_width():Float {
        return width;
    }

    public function set_width(value:Float) {
        return this.width = value;
    }

    public function set_height(value:Float) {
        return this.height = value;
    }

    public function get_height():Float {
        return height;
    }

    public function set_name(value:String) {
        return this.name = value;
    }

    public function get_name():String {
        return name;
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function addChild(node:DisplayNode):DisplayNode {
        return null;
    }

    public function addChildAt(node:DisplayNode, index:UInt):DisplayNode {
        return null;
    }

    public function getChildAt(index:UInt):DisplayNode {
        return null;
    }

    public function removeChild(node:DisplayNode):DisplayNode {
        return null;
    }

    public function removeChildAt(index:UInt):DisplayNode {
        return null;
    }

    public function registerPointerEvent(type:PointerEventType, handler:PointerEvent->Void):Void {
    }

    public function unRegisterPointerEvent(type:PointerEventType, handler:PointerEvent->Void):Void {
    }

}