package net;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import haxe.io.Output;
import haxe.io.Input;
import sys.net.Host;
import util.MappedSubscriber;
import error.ErrorManager;
import io.InputOutputStream;
import core.ObjectCreator;
class CPPSocketInputOutputStream implements TCPSocketConnector implements InputOutputStream {

    private static inline var CONNECTED: String = "connected";
    
    @inject
    public var socket: TCPSocket;
    @inject
    public var errorManager: ErrorManager;
    @inject
    public var objectCreator: ObjectCreator;
    
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

    public var bytesAvailable(get, null):Int;

    public function get_bytesAvailable():Int {
        return bufferInput.length - position;
    }

    @:isVar
    public var connected(default, null): Bool;

    private var subscriber: MappedSubscriber;
    private var input: Input;
    private var output: Output;
    private var buffer: Bytes;
    private var bufferInput: BytesInput;

    public function new() {
    }

    public function init():Void {
        subscriber = objectCreator.createInstance(MappedSubscriber);
        output = socket.output;
        input = socket.input;
        position = 0;
    }

    public function dispose():Void {
    }

    public function connect(hostname: String, port: UInt): Void {
        try {
            socket.connect(new Host(hostname), port);
            connected = true;
            subscriber.notify(CONNECTED, [this]);
        } catch(e: Dynamic) {
            errorManager.logError(e);
        }
    }

    public function close(): Void {
        if(connected) {
            socket.close();
        }
    }

    public function subscribeToConnected(callback:InputOutputStream->Void):Void {
        subscriber.subscribe(CONNECTED, callback);
    }

    public function unsubscribeToConnected(callback:InputOutputStream->Void):Void {
    }

    public function subscribeToClosed(callback:InputOutputStream->Void):Void {
    }

    public function unsubscribeToClosed(callback:InputOutputStream->Void):Void {
    }

    public function subscribeToDataReceived(callback:InputOutputStream->Void):Void {
    }

    public function unsubscribeDataReceived(callback:InputOutputStream->Void):Void {
    }

    public function update(): Void {
        position = 0;
        var bytes = input.readAll();
        var tmpBufLen: UInt = 0;
        if(buffer != null) {
            var tmpBuffer: Bytes = Bytes.alloc(bytesAvailable + bytes.length);
            for(i in 0...tmpBuffer.length) {
                tmpBuffer.set(i, buffer.get(i));
            }
            tmpBufLen = tmpBuffer.length;
            buffer = tmpBuffer;
        } else {
            buffer = Bytes.alloc(bytes.length);
        }
        for(i in 0...bytes.length) {
            var val = bytes.get(i);
            buffer.set(i + tmpBufLen, val);
        }
        bufferInput = new BytesInput(buffer, 0, buffer.length);
    }

    public function writeBoolean(value:Bool):Void {
        if(connected) {
            var bytes:Bytes = Bytes.alloc(1);
            if(value) {
                bytes.set(0, 1);
                output.write(bytes);
            } else {
                bytes.set(0, 0);
                output.write(bytes);
            }
        }
    }

    public function writeUnsignedByte(value:Int):Void {
        if(connected) {
            var bytes = Bytes.alloc(1);
            bytes.set(0, value);
            output.write(bytes);
        }
    }

    public function writeDouble(value:Float):Void {
        if(connected) {
            output.writeDouble(value);
        }
    }

    public function writeFloat(value:Float):Void {
        writeDouble(value);
    }

    public function writeInt(value:Int):Void {
        if(connected) {
            output.writeInt32(value);
        }
    }

    public function writeMultiByte(value:String, charSet:String):Void {
        throw "Is not implemented";
    }

    public function writeObject(object:Dynamic):Void {
        throw "Is not implemented";
    }

    public function writeShort(value:Int):Void {
        throw "Is not implemented";
    }

    public function writeUnsignedShort(value:Int):Void {
        if(connected) {
            output.writeUInt16(value);
        }
    }

    public function writeUTF(value:String):Void {
        throw "Is not implemented";
    }

    public function writeUTFBytes(value:String):Void {
        if(connected) {
            output.writeString(value);
        }
    }

    public function writeUnsignedInt(value:UInt):Void {
        throw "Is not implemented";
    }

    public function writeBytes(bytes:InputOutputStream, offset: Int = 0, length: Int = 0):Void {
        throw "Is not implemented";
    }

    public inline function checkConnected():Void {
        if(!connected) {
            throw "Socket is not connected";
        }
    }

    public function readBoolean():Bool {
        checkConnected();
        return bufferInput.readByte() == 1;
    }

    public function readByte():Int {
        checkConnected();
        return bufferInput.readByte();
    }

    public function readBytes(bytes:InputOutputStream, offset: Int = 0, length: Int = 0):Void {
    }

    public function readDouble():Float {
        checkConnected();
        return bufferInput.readDouble();
    }

    public function readFloat():Float {
        checkConnected();
        return bufferInput.readFloat();
    }

    public function readInt():Int {
        checkConnected();
        return bufferInput.readInt32();
    }

    public function readMultiByte(length:Int, charSet:String):String {
        return null;
    }

    public function readShort():Int {
        throw "not implemented";
        return 0;
    }

    public function readUTF():String {
        throw "not implemented";
        return null;
    }

    public function readUTFBytes(length:Int):String {
        throw "not implemented";
        return null;
    }

    public function readUnsignedByte():Int {
        throw "not implemented";
        return 0;
    }

    public function readUnsignedInt():Int {
        throw "not implemented";
        return 0;
    }

    public function readUnsignedShort():Int {
        checkConnected();
        return bufferInput.readUInt16();
    }

    public function send(data:String):Void {
    }

    public function clear():Void {
    }
}
