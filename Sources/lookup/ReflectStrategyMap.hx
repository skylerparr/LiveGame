package lookup;
import handler.actions.UnitCastedSpellAction;
import handler.input.UnitCastedSpell;
import handler.actions.UnitCastingSpellAction;
import handler.input.UnitCastingSpell;
import handler.actions.HeroCreatedAction;
import handler.input.HeroCreated;
import handler.input.UnitCreated;
import handler.input.UnitMove;
import handler.actions.UnitMoveAction;
import handler.actions.UnitCreatedAction;
import haxe.ds.ObjectMap;
import handler.actions.PlayerConnectedAction;
import handler.input.PlayerConnected;
import core.ObjectCreator;
import handler.StrategyMap;
import handler.IOHandler;
import handler.StrategyAction;
class ReflectStrategyMap implements StrategyMap {
    @inject
    public var objectCreator: ObjectCreator;

    public var handlerMap: Map<String, StrategyAction>;

    public function new() {
    }

    public function init():Void {
        handlerMap = new Map<String, StrategyAction>();

        handlerMap.set(Type.getClassName(PlayerConnected), objectCreator.createInstance(PlayerConnectedAction));
        handlerMap.set(Type.getClassName(UnitCreated), objectCreator.createInstance(UnitCreatedAction));
        handlerMap.set(Type.getClassName(HeroCreated), objectCreator.createInstance(HeroCreatedAction));
        handlerMap.set(Type.getClassName(UnitMove), objectCreator.createInstance(UnitMoveAction));
        handlerMap.set(Type.getClassName(UnitCastingSpell), objectCreator.createInstance(UnitCastingSpellAction));
        handlerMap.set(Type.getClassName(UnitCastedSpell), objectCreator.createInstance(UnitCastedSpellAction));
    }

    public function dispose():Void {
        handlerMap = null;
        objectCreator = null;
    }

    public function locate(handler:IOHandler):StrategyAction {
        return handlerMap.get(Type.getClassName(Type.getClass(handler)));
    }

}
