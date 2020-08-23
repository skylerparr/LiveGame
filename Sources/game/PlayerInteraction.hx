package game;
import vo.UnitVO;
import vo.PlayerVO;
import core.BaseObject;
interface PlayerInteraction extends BaseObject {
  function loadPlayer(playerId: Int, onComplete: PlayerVO->Void): Void;
  function getPlayerFromUnitId(unitId: Int, onComplete: PlayerVO->Void): Void;
  function associateUnitWithPlayer(player: PlayerVO, unit: UnitVO): Void;
}
