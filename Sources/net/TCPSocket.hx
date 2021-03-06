package net;
#if (multiplayer && cpp)
import sys.net.Host;
#end
interface TCPSocket {
    #if (multiplayer && cpp)
    var input(default,null) : haxe.io.Input;

    var output(default,null) : haxe.io.Output;

    function connect( host : Host, port : Int ) : Void;
    function close() : Void;
    #end
}
