package handler.input;
import constants.ByteValues;
import io.InputOutputStream;
class UnitCreated implements IOHandler {

    public var cmdId(get, null):UInt;
    public var totalBytes(get, null):UInt;

    public var playerId: Int;
    public var unitId: Int;
    public var posX: Int;
    public var posY: Int;
    public var rotation: Float;

    public function new() {
    }

    private function get_cmdId():UInt {
        return IOCommands.UNIT_CREATED;
    }

    private function get_totalBytes():UInt {
        return
            ByteValues.INT +
            ByteValues.INT +
            ByteValues.INT +
            ByteValues.INT +
            ByteValues.FLOAT;
    }

    public function read(stream:InputOutputStream):Void {
        playerId = stream.readInt();
        unitId = stream.readInt();
        posX = stream.readInt();
        posY = stream.readInt();
        rotation = stream.readFloat();
    }

    public function write(stream:InputOutputStream):Void {
    }
}
