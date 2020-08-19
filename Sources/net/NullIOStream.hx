package net;

import io.InputOutputStream;
@IgnoreCover
class NullIOStream implements InputOutputStream {
    public var bytesAvailable(get,null):UInt;
    @:isVar
    public var position(get, set):Int;

    public function new() {
    }

    function get_position():Int {
        return position;
    }

    function set_position(value:Int):Int {
        return this.position = value;
    }

    function get_bytesAvailable():UInt {
        return bytesAvailable;
    }

    public function writeFloat(value:Float):Void {
    }

    public function writeUnsignedShort(value:Int):Void {
    }

    public function writeUnsignedInt(value:UInt):Void {
    }

    public function readDouble():Float {
        return 0;
    }

    public function readFloat():Float {
        return 0;
    }

    public function readInt():Int {
        return 0;
    }

    public function readUTF():String {
        return "";
    }

    public function readUnsignedByte():Int {
        return 0;
    }

    public function writeDouble(value:Float):Void {
    }

    public function writeInt(value:Int):Void {
    }

    public function writeMultiByte(value:String, charSet:String):Void {
    }

    public function writeObject(object:Dynamic):Void {
    }

    public function clear():Void {
    }

    public function readMultiByte(length:Int, charSet:String):String {
        return "";
    }

    public function readUnsignedInt():Int {
        return 0;
    }

    public function writeBytes(bytes:InputOutputStream, offset:Int = 0, length:Int = 0):Void {
    }

    public function readShort():Int {
        return 0;
    }

    public function writeUnsignedByte(value:Int):Void {
    }

    public function writeUTFBytes(value:String):Void {
    }

    public function readUTFBytes(length:Int):String {
        return "";
    }

    public function writeUTF(value:String):Void {
    }

    public function readBoolean():Bool {
        return false;
    }

    public function readBytes(bytes:InputOutputStream, offset:Int = 0, length:Int = 0):Void {
    }

    public function writeShort(value:Int):Void {
    }

    public function readByte():Int {
        return 0;
    }

    public function send(data:String):Void {
    }

    public function readUnsignedShort():Int {
        return 0;
    }

    public function writeBoolean(value:Bool):Void {
    }
}