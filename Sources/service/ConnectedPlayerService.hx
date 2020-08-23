package service;
import vo.mutable.MutablePlayerVO;
import vo.PlayerVO;
class ConnectedPlayerService implements PlayerService {

    public var currentPlayer: MutablePlayerVO;

    @:isVar
    public var uniqueId(get, null):Int;

    public function get_uniqueId():Int {
        return uniqueId;
    }

    public function new() {
    }

    public function init():Void {
        uniqueId = 1;
        currentPlayer = new MutablePlayerVO();
    }

    public function dispose():Void {
        uniqueId = 0;
        currentPlayer = null;
    }

    public function getCurrentPlayer(onComplete:PlayerVO->Void):Void {
        if(onComplete != null) {
            onComplete(currentPlayer);
        }
    }

}
