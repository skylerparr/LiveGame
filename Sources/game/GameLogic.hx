package game;
import core.BaseObject;
interface GameLogic extends BaseObject {
  function playerConnect(playerId: UInt): Void;
  function moveUnitTo(unitId: UInt, posX: Int, posZ: Int): Void;
}
