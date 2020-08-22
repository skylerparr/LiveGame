package game.actions;
import handler.output.UnitMoveTo;
import handler.IOHandler;
import handler.StrategyAction;
class UnitMoveToAction implements StrategyAction {
  @inject
  public var gameLogic: GameLogic;

  public function new() {
  }

  public function init():Void {
  }

  public function dispose():Void {
  }

  public function execute(handler:IOHandler):Void {
    var move: UnitMoveTo = cast handler;
    gameLogic.moveUnitTo(move.unitId, move.posX, move.posZ);
  }
}
