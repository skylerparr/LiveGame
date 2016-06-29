package service;
import core.BaseObject;
import vo.PlayerVO;
interface PlayerService extends BaseObject {
    var uniqueId(get, null): Int;
    function getCurrentPlayer(onComplete: PlayerVO->Void): Void;
    function getPlayerById(id: Int, onComplete: PlayerVO->Void): Void;
}
