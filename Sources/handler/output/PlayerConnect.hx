package handler.output;
import io.InputOutputStream;
class PlayerConnect implements IOHandler {

    public var cmdId(get, null):UInt;
    public var totalBytes(get, null):UInt;

    public function new() {
    }

    function get_cmdId():UInt {
        return IOCommands.PLAYER_CONNECT;
    }

    function get_totalBytes():UInt {
        return 0;
    }

    public function read(stream:InputOutputStream):Void {
    }

    public function write(stream:InputOutputStream):Void {
        stream.writeUnsignedByte(cmdId);
    }
}
