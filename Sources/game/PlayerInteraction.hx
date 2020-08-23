package game;
import vo.UnitVO;
import vo.PlayerVO;
import core.BaseObject;
interface PlayerInteraction extends BaseObject {
  function loadPlayer(playerId: Int, onComplete: Null<PlayerVO>->Void): Void;
  function createUnit(player: PlayerVO, unitType: Int, onComplete: Null<UnitVO> -> Void): Void;
}
