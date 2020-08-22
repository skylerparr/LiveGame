package game;
import game.actions.UnitCastSpellAction;
import handler.output.UnitCastSpell;
import game.actions.UnitMoveToAction;
import handler.output.UnitMoveTo;
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
    handlerMap.set(Type.getClassName(UnitMoveTo), objectCreator.createInstance(UnitMoveToAction));
    handlerMap.set(Type.getClassName(UnitCastSpell), objectCreator.createInstance(UnitCastSpellAction));
  }

  public function dispose():Void {
    handlerMap = null;
    objectCreator = null;
  }

  public function locate(handler:IOHandler):StrategyAction {
    return handlerMap.get(Type.getClassName(Type.getClass(handler)));
  }
}
