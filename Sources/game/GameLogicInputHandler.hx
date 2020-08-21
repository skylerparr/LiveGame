package game;
import handler.StrategyAction;
import handler.StrategyMap;
import handler.IOHandler;
class GameLogicInputHandler implements GameLogicInput {
  @inject("GameLogicStrategyMap")
  public var strategyMap: StrategyMap;

  public function new() {
  }

  public function init():Void {
  }

  public function dispose():Void {
    strategyMap = null;
  }

  public function input(handler:IOHandler):Void {
    var action: StrategyAction = strategyMap.locate(handler);
    // todo: remove me
    if(action == null) {
      trace('action for ${handler} is null');
      return;
    }
    action.execute(handler);
  }

}
