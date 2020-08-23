package game;
import handler.output.UnitCastSpell;
import handler.output.UnitMoveTo;
import handler.output.PlayerConnect;
import handler.IOCommands;
import handler.StrategyAction;
import handler.StrategyMap;
import handler.IOHandler;
class GameLogicInputHandler implements GameLogicInput {
  @inject
  public var gameLogic: GameLogic;

  public function new() {
  }

  public function init():Void {
  }

  public function dispose():Void {
    gameLogic = null;
  }

  public function input(handler:IOHandler):Void {
    switch(handler.cmdId) {
      case IOCommands.UNIT_MOVE_TO:
        var h: UnitMoveTo = cast handler;
        gameLogic.moveUnitTo(h.unitId, h.posX, h.posZ);
      case IOCommands.UNIT_CAST_SPELL:
        var h: UnitCastSpell = cast handler;
        gameLogic.unitCastSpell(h.unitId, h.spellId, h.targetUnitId, h.targetPosX, h.targetPosZ);
      case IOCommands.PLAYER_CONNECT:
        var h: PlayerConnect = cast handler;
        gameLogic.playerConnect(h.playerId);
      case _:
        trace('unhandled action ${handler}');
    }
  }

}
