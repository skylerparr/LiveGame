package net;
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

    public function new() {
    }

    public function init():Void {
        subscriber = objectCreator.createInstance(MappedSubscriber);
    }

    public function dispose():Void {
    }

    public function connect(hostname: String, port: UInt): Void {
        try {
            socket.connect(new Host(hostname), port);
            subscriber.notify(CONNECTED, [this]);
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
    }

    public function writeByte(value:Int):Void {
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
