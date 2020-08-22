package game;
import core.BaseObject;
interface GameLogic extends BaseObject {
  function playerConnect(playerId: UInt): Void;
  function moveUnitTo(unitId: UInt, posX: Int, posZ: Int): Void;
  function unitCastSpell(unitId: Int, spellId: Int, targetUnitId: Int, targetPosX: Int, targetPosZ: Int): Void;
}
