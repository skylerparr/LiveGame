package handler.input;
import constants.ByteValues;
import io.InputOutputStream;
class PlayerConnected implements IOHandler {

    public var cmdId(get, null):UInt;
    public var totalBytes(get, null):UInt;

    public var playerId: Int;

    private function get_cmdId():UInt {
        return IOCommands.PLAYER_CONNECTED;
    }

    private function get_totalBytes():UInt {
        return ByteValues.INT;
    }

    public function new() {
    }

    public function read(stream:InputOutputStream):Void {
        playerId = stream.readInt();
    }

    public function write(stream:InputOutputStream):Void {
        stream.writeUnsignedByte(cmdId);
        stream.writeUnsignedInt(playerId);
    }

}
