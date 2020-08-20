package net;

import haxe.io.Input;
import haxe.io.Output;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import io.InputOutputStream;
@IgnoreCover
class BufferIOStream implements InputOutputStream {

    public var output: Output;
    public var buffer: Bytes;
    public var bufferInput: BytesInput;

    @:isVar
    public var position(get, set):Int;

    public function set_position(value:Int) {
        return value;
    }

    public function get_position():Int {
        if(bufferInput == null) {
            return 0;
        }
        return bufferInput.position;
    }

    public var bytesAvailable(get, null):UInt;

    public function get_bytesAvailable():UInt {
        if(bufferInput == null) {
            return 0;
        }
        return bufferInput.length - position;
    }

    public function new(output: Output) {
        this.output = output;
        this.bufferInput = new BytesInput(Bytes.alloc(64), 0, 0);
    }

    public function writeBoolean(value:Bool):Void {
        var bytes:Bytes = Bytes.alloc(1);
        if(value) {
            bytes.set(0, 1);
            output.write(bytes);
        } else {
            bytes.set(0, 0);
            output.write(bytes);
        }
    }

    public function writeUnsignedByte(value:Int):Void {
        var bytes: Bytes = Bytes.alloc(1);
        bytes.set(0, value);
        output.write(bytes);
    }

    public function writeDouble(value:Float):Void {
        output.writeDouble(value);
    }

    public function writeFloat(value:Float):Void {
        writeDouble(value);
    }

    public function writeInt(value:Int):Void {
        output.writeInt32(value);
    }

    public function writeMultiByte(value:String, charSet:String):Void {
        throw "write multibyte Is not implemented";
    }

    public function writeObject(object:Dynamic):Void {
        throw "write object Is not implemented";
    }

    public function writeShort(value:Int):Void {
        throw "write short Is not implemented";
    }

    public function writeUnsignedShort(value:Int):Void {
        output.writeUInt16(value);
    }

    public function writeUTF(value:String):Void {
        throw "write utf Is not implemented";
    }

    public function writeUTFBytes(value:String):Void {
        output.writeString(value);
    }

    public function writeUnsignedInt(value:UInt):Void {
        throw "write unsigned int Is not implemented";
    }

    public function writeBytes(bytes:InputOutputStream, offset: Int = 0, length: Int = 0):Void {
        throw "Is not implemented";
    }

    public function readBoolean():Bool {
        return bufferInput.readByte() == 1;
    }

    public function readByte():Int {
        throw "read byte not implemented";
    }

    public function readBytes(bytes:InputOutputStream, offset: Int = 0, length: Int = 0):Void {
    }

    public function readDouble():Float {
        return bufferInput.readDouble();
    }

    public function readFloat():Float {
        return bufferInput.readFloat();
    }

    public function readInt():Int {
        return bufferInput.readInt32();
    }

    public function readMultiByte(length:Int, charSet:String):String {
        return null;
    }

    public function readShort():Int {
        throw "read short not implemented";
    }

    public function readUTF():String {
        throw "read utf not implemented";
    }

    public function readUTFBytes(length:Int):String {
        return bufferInput.readString(length);
    }

    public function readUnsignedByte():Int {
        return bufferInput.readByte();
    }

    public function readUnsignedInt():Int {
        throw "read unsigned int not implemented";
    }

    public function readUnsignedShort():Int {
        return bufferInput.readUInt16();
    }

    public function send(data:String):Void {
    }

    public function clear():Void {
    }
}