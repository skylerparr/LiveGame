package handler.input;
import constants.ByteValues;
import io.InputOutputStream;
class UnitMove implements IOHandler {
    public var cmdId(get, null):UInt;

    public var totalBytes(get, null):UInt;

    public function new() {
    }

    public var unitId: Int;
    public var posX: Float;
    public var posZ: Float;
    public var time: Int;

    function get_cmdId():UInt {
        return IOCommands.UNIT_MOVE;
    }

    function get_totalBytes():UInt {
        return ByteValues.INT +
            ByteValues.FLOAT +
            ByteValues.FLOAT +
            ByteValues.INT;
    }

    public function read(stream:InputOutputStream):Void {
        unitId = stream.readInt();
        posX = stream.readFloat();
        posZ = stream.readFloat();
        time = stream.readInt();
    }

    public function write(stream:InputOutputStream):Void {
    }
}
