package net;
import sys.net.Socket;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import haxe.io.Output;
import haxe.io.Input;
import sys.net.Host;
import util.MappedSubscriber;
import error.Logger;
import io.InputOutputStream;
import core.ObjectCreator;
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
        if(bufferInput == null) {
            return 0;
        }
        return bufferInput.length - position;
    }

    @:isVar
    public var connected(default, null): Bool;

    public var subscriber: MappedSubscriber;
    public var input: Input;
    public var output: Output;
    public var buffer: Bytes;
    public var bufferInput: BytesInput;

    public function new() {
    }

    public function init():Void {
        subscriber = objectCreator.createInstance(MappedSubscriber);
    }

    public function dispose():Void {
        close();
        objectCreator.disposeInstance(subscriber);
        subscriber = null;
        input = null;
        output = null;
        socket = null;
        errorManager = null;
        objectCreator = null;
    }

    public function connect(hostname: String, port: UInt): Void {
        if(connected) {
            return;
        }
        try {
            output = socket.output;
            input = socket.input;
            position = 0;
            socket.connect(new Host(hostname), port);
        } catch(e: Dynamic) {
            if(e == "Blocking") {
                connected = true;
                subscriber.notify(CONNECTED, [this]);
            } else {
                errorManager.logError(e);
            }
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
        bufferInput = null;
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
            }
        }
        var tmpBufLen: UInt = 0;
        if(buffer != null) {
            var tmpBuffer: Bytes = Bytes.alloc(bytesAvailable + lengthReady);
            for(i in 0...tmpBuffer.length) {
                tmpBuffer.set(i, buffer.get(i));
            }
            tmpBufLen = tmpBuffer.length;
            buffer = tmpBuffer;
        } else {
            buffer = Bytes.alloc(lengthReady);
        }
        var posOffset = bytesAvailable;
        buffer.blit(posOffset, readBuffer, 0, lengthReady);
        bufferInput = new BytesInput(buffer, 0, buffer.length);
        subscriber.notify(DATA, [this]);
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
            output.writeUInt16(value);
        }
    }

    public function writeUTF(value:String):Void {
        throw "write utf Is not implemented";
    }

    public function writeUTFBytes(value:String):Void {
        if(connected) {
            output.writeString(value);
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
        return bufferInput.readByte() == 1;
    }

    public function readByte():Int {
        throw "read byte not implemented";
        return 0;
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
        throw "read short not implemented";
        return 0;
    }

    public function readUTF():String {
        throw "read utf not implemented";
        return null;
    }

    public function readUTFBytes(length:Int):String {
        checkConnected();
        return bufferInput.readString(length);
    }

    public function readUnsignedByte():Int {
        checkConnected();
        return bufferInput.readByte();
    }

    public function readUnsignedInt():Int {
        throw "read unsigned int not implemented";
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

    public function waitForRead(): Bool {
        var ourSocket: Socket = cast(socket, CPPTCPSocket).socket;
        var r = Socket.select([ourSocket],null,null,0);
        if( r.read[0] == ourSocket ) {
            return true;
        }
        return false;
    }
}
