package service;
import vo.PlayerVO;
interface PlayerService {
    function getPlayerById(id: Int, onComplete: PlayerVO->Void): Void;
}
