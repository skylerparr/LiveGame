package game.actions;
import handler.output.PlayerConnect;
import handler.IOHandler;
import handler.StrategyAction;
class PlayerConnectAction implements StrategyAction {
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
    var handler: PlayerConnect = cast handler;
    gameLogic.playerConnect(handler.playerId);
  }
}
