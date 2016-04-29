package mocks;

import sys.net.Host;
import net.TCPSocket;
class MockTCPSocket implements TCPSocket {

    public var input(default, default):haxe.io.Input;

    public var output(default, default):haxe.io.Output;

    public function connect(host:Host, port:Int):Void {
    }

    public function close():Void {
    }
}