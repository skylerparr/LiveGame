package io;
interface InputOutputStream extends InputStream extends OutputStream {
    var position(get, set): Int;
    function send(data: String): Void;
    function clear(): Void;
}
