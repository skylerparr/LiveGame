package handler.input;
import io.InputOutputStream;
import constants.ByteValues;
class UnitCastedSpell implements IOHandler {
    public var cmdId(get, null):UInt;

    public var totalBytes(get, null):UInt;

    public function new() {
    }

    public var unitId: Int;
    public var spellId: Int;
    public var posX: Float;
    public var posZ: Float;
    public var targetUnitId: Int;

    function get_cmdId():UInt {
        return IOCommands.UNIT_CASTING_SPELL;
    }

    function get_totalBytes():UInt {
        return ByteValues.INT +
        ByteValues.INT +
        ByteValues.FLOAT +
        ByteValues.FLOAT +
        ByteValues.INT;
    }

    public function read(stream:InputOutputStream):Void {
        unitId = stream.readInt();
        spellId = stream.readInt();
        posX = stream.readFloat();
        posZ = stream.readFloat();
        targetUnitId = stream.readInt();
    }

    public function write(stream:InputOutputStream):Void {
    }
}
