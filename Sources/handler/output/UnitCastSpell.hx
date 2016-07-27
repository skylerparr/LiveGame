package handler.output;
import io.InputOutputStream;
class UnitCastSpell implements IOHandler {

    public var cmdId(get, null):UInt;
    public var totalBytes(get, null):UInt;

    function get_cmdId():UInt {
        return IOCommands.UNIT_CAST_SPELL;
    }

    function get_totalBytes():UInt {
        return 0;
    }

    public var unitId: Int;
    public var spellId: Int;
    public var targetUnitId: Int;
    public var targetPosX: Int;
    public var targetPosZ: Int;

    public function new() {
    }

    public function read(stream:InputOutputStream):Void {
    }

    public function write(stream:InputOutputStream):Void {
        stream.writeUnsignedByte(cmdId);
        stream.writeInt(unitId);
        stream.writeInt(spellId);
        stream.writeInt(targetUnitId);
        stream.writeInt(targetPosX);
        stream.writeInt(targetPosZ);
    }
}