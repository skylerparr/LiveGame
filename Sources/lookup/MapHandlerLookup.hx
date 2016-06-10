package lookup;
import handler.input.UnitMove;
import handler.input.UnitCreated;
import handler.input.PlayerConnected;
import handler.IOCommands;
import handler.IOHandler;
import handler.HandlerLookup;
import io.InputOutputStream;
class MapHandlerLookup implements HandlerLookup {

    public var map: Map<Int, IOHandler>;

    public function new() {
    }

    public function init():Void {
        map = new Map<Int, IOHandler>();

        map.set(IOCommands.PLAYER_CONNECTED, new PlayerConnected());
        map.set(IOCommands.UNIT_CREATED, new UnitCreated());
        map.set(IOCommands.UNIT_MOVE, new UnitMove());
    }

    public function dispose():Void {
        map = null;
    }

    public function getHandler(stream:InputOutputStream):IOHandler {
        if(stream.bytesAvailable == 0) {
            return null;
        }
        return map.get(stream.readUnsignedByte());
    }
}
