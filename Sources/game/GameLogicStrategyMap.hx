package game;
import game.actions.PlayerConnectAction;
import handler.output.PlayerConnect;
import core.ObjectCreator;
import handler.StrategyAction;
import handler.IOHandler;
import handler.StrategyMap;
class GameLogicStrategyMap implements StrategyMap {
  @inject
  public var objectCreator: ObjectCreator;

  public var handlerMap: Map<String, StrategyAction>;

  public function new() {
  }

  public function init():Void {
    handlerMap = new Map<String, StrategyAction>();

    handlerMap.set(Type.getClassName(PlayerConnect), objectCreator.createInstance(PlayerConnectAction));
  }

  public function dispose():Void {
    handlerMap = null;
    objectCreator = null;
  }

  public function locate(handler:IOHandler):StrategyAction {
    return handlerMap.get(Type.getClassName(Type.getClass(handler)));
  }
}
