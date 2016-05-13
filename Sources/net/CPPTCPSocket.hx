package net;
import sys.net.Socket;
import sys.net.Host;
class CPPTCPSocket implements TCPSocket {
    public var input(default, null):haxe.io.Input;

    public var output(default, null):haxe.io.Output;

    public var socket(default, null): Socket;

    public function new() {
        socket = new Socket();
        input = socket.input;
        output = socket.output;
        output.bigEndian = true;
        socket.setBlocking(false);
        socket.setFastSend(true);
    }

    public function connect(host:Host, port:Int):Void {
        socket.connect(host, port);
    }

    public function close():Void {
        socket.close();
    }

}
