package game.actions;
import handler.output.UnitCastSpell;
import handler.IOHandler;
import handler.StrategyAction;
class UnitCastSpellAction implements StrategyAction {
  @inject
  public var gameLogic: GameLogic;

  public function new() {
  }

  public function init():Void {
  }

  public function dispose():Void {
    gameLogic = null;
  }

  public function execute(handler:IOHandler):Void {
    var handler: UnitCastSpell = cast handler;
    gameLogic.unitCastSpell(
      handler.unitId,
      handler.spellId,
      handler.targetUnitId,
      handler.targetPosX,
      handler.targetPosZ
    );
  }
}
