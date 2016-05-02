package net;
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
        return this.position = value;
    }

    public function get_position():Int {
        return position;
    }

    @:isVar
    public var bytesAvailable(get, null):Int;

    public function get_bytesAvailable():Int {
        return bytesAvailable;
    }

    @:isVar
    public var connected(default, null): Bool;

    private var subscriber: MappedSubscriber;
    private var input: Input;
    private var output: Output;

    public function new() {
    }

    public function init():Void {
        subscriber = objectCreator.createInstance(MappedSubscriber);
        input = socket.input;
        output = socket.output;
    }

    public function dispose():Void {
    }

    public function connect(hostname: String, port: UInt): Void {
        try {
            socket.connect(new Host(hostname), port);
            subscriber.notify(CONNECTED, [this]);
            connected = true;
        } catch(e: Dynamic) {
            errorManager.logError(e);
        }
    }

    public function close(): Void {

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
    }

    public function writeFloat(value:Float):Void {
    }

    public function writeInt(value:Int):Void {
        if(connected) {
            output.writeInt16(value);
        }
    }

    public function writeMultiByte(value:String, charSet:String):Void {
    }

    public function writeObject(object:Dynamic):Void {
    }

    public function writeShort(value:Int):Void {
        if(connected) {
            output.writeInt8(value);
        }
    }

    public function writeUTF(value:String):Void {
    }

    public function writeUTFBytes(value:String):Void {
    }

    public function writeUnsignedInt(value:Int):Void {
    }

    public function writeBytes(bytes:InputOutputStream, offset: Int = 0, length: Int = 0):Void {
    }

    public function readBoolean():Bool {
        return false;
    }

    public function readByte():Int {
        return 0;
    }

    public function readBytes(bytes:InputOutputStream, offset: Int = 0, length: Int = 0):Void {
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

    public function send(data:String):Void {
    }

    public function clear():Void {
    }
}
