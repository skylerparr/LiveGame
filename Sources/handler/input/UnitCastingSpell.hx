package handler.input;
import io.InputOutputStream;
import constants.ByteValues;
class UnitCastingSpell implements IOHandler {
    public var cmdId(get, null):UInt;

    public var totalBytes(get, null):UInt;

    public function new() {
    }

    public var unitId: Int;
    public var spellId: Int;
    public var posX: Int;
    public var posZ: Int;

    function get_cmdId():UInt {
        return IOCommands.UNIT_CASTING_SPELL;
    }

    function get_totalBytes():UInt {
        return ByteValues.INT +
        ByteValues.INT +
        ByteValues.INT +
        ByteValues.INT;
    }

    public function read(stream:InputOutputStream):Void {
        unitId = stream.readInt();
        spellId = stream.readInt();
        posX = stream.readInt();
        posZ = stream.readInt();
    }

    public function write(stream:InputOutputStream):Void {
    }
}
