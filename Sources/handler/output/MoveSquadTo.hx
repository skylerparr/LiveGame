package handler.output;
import io.InputOutputStream;
class MoveSquadTo implements IOHandler {

    public var cmdId(get, null):UInt;
    public var totalBytes(get, null):UInt;

    function get_cmdId():UInt {
        return IOCommands.MOVE_SQUAD_TO;
    }

    function get_totalBytes():UInt {
        return 0;
    }

    public var unitId: Int;
    public var posX: Int;
    public var posZ: Int;

    public function new() {
    }

    public function read(stream:InputOutputStream):Void {
    }

    public function write(stream:InputOutputStream):Void {
        stream.writeUnsignedByte(cmdId);
        stream.writeInt(unitId);
        stream.writeInt(posX);
        stream.writeInt(posZ);
    }

}
