package actions.input;
import io.OutputStream;
import io.InputStream;
class UnitMove {

    public static inline var ID: Int = 1;
    public static inline var LENGTH: Int = 28;

    public var unitId: UInt;
    public var x: Float;
    public var y: Float;
    public var rotation: Float;

    public function new() {
    }

    public function read(stream: InputStream): Void {
        unitId = stream.readUnsignedInt();
        x = stream.readFloat();
        y = stream.readFloat();
        rotation = stream.readFloat();
    }

    public function write(stream: OutputStream): Void {
        stream.writeUnsignedInt(ID);
        stream.writeUnsignedInt(unitId);
        stream.writeFloat(x);
        stream.writeFloat(y);
        stream.writeFloat(rotation);
    }
}
