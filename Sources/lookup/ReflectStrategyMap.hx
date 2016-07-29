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

    public var handlerMap: ObjectMap<Dynamic, StrategyAction>;

    public function new() {
    }

    public function init():Void {
        handlerMap = new ObjectMap<Dynamic, StrategyAction>();

        handlerMap.set(PlayerConnected, objectCreator.createInstance(PlayerConnectedAction));
        handlerMap.set(UnitCreated, objectCreator.createInstance(UnitCreatedAction));
        handlerMap.set(HeroCreated, objectCreator.createInstance(HeroCreatedAction));
        handlerMap.set(UnitMove, objectCreator.createInstance(UnitMoveAction));
        handlerMap.set(UnitCastingSpell, objectCreator.createInstance(UnitCastingSpellAction));
        handlerMap.set(UnitCastedSpell, objectCreator.createInstance(UnitCastedSpellAction));
    }

    public function dispose():Void {
    }

    public function locate(handler:IOHandler):StrategyAction {
        return handlerMap.get(Type.getClass(handler));
    }

}
