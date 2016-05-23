package handler;
import io.InputOutputStream;
interface IOHandler {
    var cmdId(get, null): UInt;
    var totalBytes(get, null): UInt;

    function read(stream: InputOutputStream): Void;
    function write(stream: InputOutputStream): Void;
}
