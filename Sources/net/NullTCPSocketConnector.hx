package net;

import io.InputOutputStream;
class NullTCPSocketConnector implements TCPSocketConnector {

    public var connected(default, null):Bool;

    public function init():Void {
    }

    public function subscribeToConnected(callback:(InputOutputStream) -> Void):Void {
    }

    public function unsubscribeToConnected(callback:(InputOutputStream) -> Void):Void {
    }

    public function unsubscribeToClosed(callback:(InputOutputStream) -> Void):Void {
    }

    public function dispose():Void {
    }

    public function connect(hostname:String, port:UInt):Void {
    }

    public function close():Void {
    }

    public function subscribeToClosed(callback:(InputOutputStream) -> Void):Void {
    }

    public function subscribeToDataReceived(callback:(InputOutputStream) -> Void):Void {
    }

    public function unsubscribeDataReceived(callback:(InputOutputStream) -> Void):Void {
    }
}

