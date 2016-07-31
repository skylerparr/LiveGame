package service;
import vo.mutable.MutablePlayerVO;
import vo.UnitVO;
import vo.PlayerVO;
class ConnectedPlayerService implements PlayerService {

    private var currentPlayer: MutablePlayerVO;

    @:isVar
    public var uniqueId(get, null):Int;

    function get_uniqueId():Int {
        return uniqueId;
    }

    public function new() {
    }

    public function init():Void {
        uniqueId = Std.random(65535);

        currentPlayer = new MutablePlayerVO();
        currentPlayer.units = new Map<Int, UnitVO>();
    }

    public function dispose():Void {
    }

    public function getCurrentPlayer(onComplete:PlayerVO->Void):Void {
        onComplete(currentPlayer);
    }

    public function getPlayerById(id:Int, onComplete: PlayerVO->Void):Void {
    }
}
