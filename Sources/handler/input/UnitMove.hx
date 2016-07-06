package handler.input;
import constants.ByteValues;
import io.InputOutputStream;
class UnitMove implements IOHandler {
    public var cmdId(get, null):UInt;

    public var totalBytes(get, null):UInt;

    public function new() {
    }

    public var unitId: Int;
    public var posX: Int;
    public var posZ: Int;
    public var time: Int;

    function get_cmdId():UInt {
        return IOCommands.UNIT_MOVE;
    }

    function get_totalBytes():UInt {
        return ByteValues.INT +
            ByteValues.INT +
            ByteValues.INT +
            ByteValues.INT;
    }

    public function read(stream:InputOutputStream):Void {
        unitId = stream.readInt();
        posX = stream.readInt();
        posZ = stream.readInt();
        time = stream.readInt();
    }

    public function write(stream:InputOutputStream):Void {
    }
}
