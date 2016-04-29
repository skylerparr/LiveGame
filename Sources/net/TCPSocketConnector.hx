package net;
import core.BaseObject;
import io.InputOutputStream;
interface TCPSocketConnector extends BaseObject {
    var connected(default, null): Bool;

    function connect(hostname: String, port: UInt): Void;
    function close(): Void;

    function subscribeToConnected(callback: InputOutputStream->Void): Void;
    function unsubscribeToConnected(callback: InputOutputStream->Void): Void;
    function subscribeToClosed(callback: InputOutputStream->Void): Void;
    function unsubscribeToClosed(callback: InputOutputStream->Void): Void;
    function subscribeToDataReceived(callback: InputOutputStream->Void): Void;
    function unsubscribeDataReceived(callback: InputOutputStream->Void): Void;
}
