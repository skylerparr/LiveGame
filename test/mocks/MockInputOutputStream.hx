package mocks;

import io.InputOutputStream;
class MockInputOutputStream implements InputOutputStream {

    public function writeBoolean(value:Bool):Void {
    }

    public function writeUnsignedByte(value:Int):Void {
    }

    public function writeDouble(value:Float):Void {
    }

    public function writeFloat(value:Float):Void {
    }

    public function writeInt(value:Int):Void {
    }

    public function writeMultiByte(value:String, charSet:String):Void {
    }

    public function writeObject(object:Dynamic):Void {
    }

    public function writeShort(value:Int):Void {
    }

    public function writeUnsignedShort(value:Int):Void {
    }

    public function writeUTF(value:String):Void {
    }

    public function writeUTFBytes(value:String):Void {
    }

    public function writeUnsignedInt(value:UInt):Void {
    }

    public function writeBytes(bytes:InputOutputStream, offset:Int = 0, length:Int = 0):Void {
    }

    @:isVar
    public var bytesAvailable(get, set):Int;

    public function set_bytesAvailable(value:Int) {
        return this.bytesAvailable = value;
    }

    public function get_bytesAvailable():Int {
        return bytesAvailable;
    }

    public function readBoolean():Bool {
        return false;
    }

    public function readByte():Int {
        return 0;
    }

    public function readBytes(bytes:InputOutputStream, offset:Int = 0, length:Int = 0):Void {

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

    public function readMultiByte(length:Int, charSet:String):String {
        return null;
    }

    public function readShort():Int {
        return 0;
    }

    public function readUTF():String {
        return null;
    }

    public function readUTFBytes(length:Int):String {
        return null;
    }

    public function readUnsignedByte():Int {
        return 0;
    }

    public function readUnsignedInt():Int {
        return 0;
    }

    public function readUnsignedShort():Int {
        return 0;
    }

    @:isVar
    public var position(get, set):Int;

    public function set_position(value:Int) {
        return this.position = value;
    }

    public function get_position():Int {
        return position;
    }

    public function send(data:String):Void {
    }

    public function clear():Void {
    }
}