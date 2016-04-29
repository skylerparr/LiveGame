package net;
import sys.net.Host;
interface TCPSocket {
    var input(default,null) : haxe.io.Input;

    var output(default,null) : haxe.io.Output;

    function connect( host : Host, port : Int ) : Void;
    function close() : Void;
}
