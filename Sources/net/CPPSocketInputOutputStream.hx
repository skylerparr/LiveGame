package net;
#if (multiplayer && cpp)
import sys.net.Socket;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import haxe.io.Output;
import haxe.io.Input;
import sys.net.Host;
#end
import util.MappedSubscriber;
import error.Logger;
import io.InputOutputStream;
import core.ObjectCreator;
#if (multiplayer && cpp)
class CPPSocketInputOutputStream implements TCPSocketConnector implements InputOutputStream {

    private static inline var CONNECTED: String = "connected";
    private static inline var CLOSED: String = "closed";
    private static inline var DATA: String = "data";

    @inject
    public var socket: TCPSocket;
    @inject
    public var errorManager: Logger;
    @inject
    public var objectCreator: ObjectCreator;
    
    public var position(get, set):Int;

    public function set_position(value:Int) {
        if(buffer == null) {
          return 0;
        }
        return buffer.position = value;
    }

    public function get_position():Int {
        if(buffer == null) {
          return 0;
        }
        return buffer.position;
    }

    public var bytesAvailable(get, null):UInt;

    public function get_bytesAvailable():UInt {
        if(buffer == null) {
          return 0;
        }
        return buffer.bytesAvailable;
    }

    @:isVar
    public var connected(default, null): Bool;

    public var subscriber: MappedSubscriber;
    public var buffer: BufferIOStream;
    public var input: Input;

    public function new() {
    }

    public function init():Void {
        subscriber = objectCreator.createInstance(MappedSubscriber);
    }

    public function dispose():Void {
        close();
        objectCreator.disposeInstance(subscriber);
        subscriber = null;
        buffer = null;
        input = null;
        socket = null;
        errorManager = null;
        objectCreator = null;
    }

    public function connect(hostname: String, port: UInt): Void {
        if(connected) {
            return;
        }
        buffer = objectCreator.createInstance(BufferIOStream, [socket.output]);
        input = socket.input;
        try {
            socket.connect(new Host(hostname), port);
            connected = true;
            Sys.sleep(0.01); //give the server a moment to process this
            subscriber.notify(CONNECTED, [this]);
        } catch(e: Dynamic) {
            errorManager.logError(e);
        }
    }

    public function close(): Void {
        if(connected) {
            socket.close();
            clearBuffer();
            subscriber.notify(CLOSED, [this]);
        }
    }

    private inline function clearBuffer(): Void {
        input = null;
        buffer = null;
        connected = false;
    }

    public function subscribeToConnected(callback:InputOutputStream->Void):Void {
        subscriber.subscribe(CONNECTED, callback);
    }

    public function unsubscribeToConnected(callback:InputOutputStream->Void):Void {
        subscriber.unsubscribe(CONNECTED, callback);
    }

    public function subscribeToClosed(callback:InputOutputStream->Void):Void {
        subscriber.subscribe(CLOSED, callback);
    }

    public function unsubscribeToClosed(callback:InputOutputStream->Void):Void {
        subscriber.unsubscribe(CLOSED, callback);
    }

    public function subscribeToDataReceived(callback:InputOutputStream->Void):Void {
        subscriber.subscribe(DATA, callback);
    }

    public function unsubscribeDataReceived(callback:InputOutputStream->Void):Void {
        subscriber.unsubscribe(DATA, callback);
    }

    public function update(): Void {
        if(!waitForRead()) {
            return;
        }
        position = 0;
        var readBuffer = Bytes.alloc(64);
        var lengthReady: Int = 0;
        try {
            lengthReady = input.readBytes(readBuffer, 0, readBuffer.length);
        } catch(e: Dynamic) {
            if(e == "Eof") {
                close();
                return;
            }
        }
        if(buffer.buffer != null) {
            var tmpBuffer: Bytes = Bytes.alloc(bytesAvailable + lengthReady);
            tmpBuffer.blit(0, buffer.buffer, position, bytesAvailable);
            buffer.buffer = tmpBuffer;
        } else {
            buffer.buffer = Bytes.alloc(lengthReady);
        }
        var posOffset = bytesAvailable;
        buffer.buffer.blit(posOffset, readBuffer, 0, lengthReady);
        buffer.bufferInput = new BytesInput(buffer.buffer, 0, buffer.buffer.length);
        subscriber.notify(DATA, [this]);
    }

    public function writeBoolean(value:Bool):Void {
        if(connected) {
            buffer.writeBoolean(value);
        }
    }

    public function writeUnsignedByte(value:Int):Void {
        if(connected) {
            buffer.writeUnsignedByte(value);
        }
    }

    public function writeDouble(value:Float):Void {
        if(connected) {
            buffer.writeDouble(value);
        }
    }

    public function writeFloat(value:Float):Void {
        writeDouble(value);
    }

    public function writeInt(value:Int):Void {
        if(connected) {
            buffer.writeInt(value);
        }
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
        if(connected) {
            buffer.writeUnsignedShort(value);
        }
    }

    public function writeUTF(value:String):Void {
        throw "write utf Is not implemented";
    }

    public function writeUTFBytes(value:String):Void {
        if(connected) {
            buffer.writeUTFBytes(value);
        }
    }

    public function writeUnsignedInt(value:UInt):Void {
        throw "write unsigned int Is not implemented";
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
        return buffer.readBoolean();
    }

    public function readByte():Int {
        throw "read byte not implemented";
        return 0;
    }

    public function readBytes(bytes:InputOutputStream, offset: Int = 0, length: Int = 0):Void {
    }

    public function readDouble():Float {
        checkConnected();
        return buffer.readDouble();
    }

    public function readFloat():Float {
        checkConnected();
        return buffer.readFloat();
    }

    public function readInt():Int {
        checkConnected();
        return buffer.readInt();
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
        checkConnected();
        return buffer.readUTFBytes(length);
    }

    public function readUnsignedByte():Int {
        checkConnected();
        return buffer.readUnsignedByte();
    }

    public function readUnsignedInt():Int {
        throw "read unsigned int not implemented";
    }

    public function readUnsignedShort():Int {
        checkConnected();
        return buffer.readUnsignedShort();
    }

    public function send(data:String):Void {
    }

    public function clear():Void {
    }

    public function waitForRead(): Bool {
        var ourSocket: Socket = cast(socket, CPPTCPSocket).socket;
        var r = Socket.select([ourSocket],null,null,0);
        if( r.read[0] == ourSocket ) {
            return true;
        }
        return false;
    }
}
#end