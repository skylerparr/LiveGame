package lookup;

import handler.StrategyAction;
import handler.IOHandler;
import handler.input.UnitCastedSpell;
import handler.actions.UnitCastedSpellAction;
import handler.input.UnitCastingSpell;
import handler.actions.UnitCastingSpellAction;
import handler.input.HeroCreated;
import handler.actions.HeroCreatedAction;
import world.GameObject;
import haxe.ds.ObjectMap;
import handler.actions.UnitMoveAction;
import handler.actions.UnitCreatedAction;
import handler.input.UnitMove;
import handler.input.UnitCreated;
import handler.output.PlayerConnect;
import core.ObjectCreator;
import lookup.ReflectStrategyMap;
import handler.actions.PlayerConnectedAction;
import handler.StrategyAction;
import handler.input.PlayerConnected;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class ReflectStrategyMapTest {

    private var strategyMap: ReflectStrategyMap;
    private var objectCreator: ObjectCreator;
    private var expectedAction: StrategyAction;

    @Before
    public function setup():Void {
        objectCreator = mock(ObjectCreator);

        strategyMap = new ReflectStrategyMap();
        strategyMap.objectCreator = objectCreator;
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldGetPlayerConnectedAction(): Void {
        validateAction(PlayerConnectedAction, PlayerConnected);
    }

    @Test
    public function shouldGetUnitCreatedAction(): Void {
        validateAction(UnitCreatedAction, UnitCreated);
    }

    @Test
    public function shouldGetUnitMoveAction(): Void {
        validateAction(UnitMoveAction, UnitMove);
    }

    @Test
    public function shouldGetHeroCreatedAction(): Void {
        validateAction(HeroCreatedAction, HeroCreated);
    }

    @Test
    public function shouldGetUnitCastingSpellAction(): Void {
        validateAction(UnitCastingSpellAction, UnitCastingSpell);
    }

    @Test
    public function shouldGetUnitCastedSpellAction(): Void {
        validateAction(UnitCastedSpellAction, UnitCastedSpell);
    }

    @Test
    public function shouldReturnNullIfStrategyIsNotFound(): Void {
        strategyMap.init();

        var action: StrategyAction = strategyMap.locate(new PlayerConnect());
        Assert.isNull(action);
    }

    @Test
    public function shouldDisposeStrategyMap(): Void {
        strategyMap.init();
        strategyMap.dispose();

        Assert.isNull(strategyMap.handlerMap);
        Assert.isNull(strategyMap.objectCreator);
    }

    @IgnoreCover
    private function validateAction(action:Class<StrategyAction>, handler: Class<IOHandler>):Void {
        expectedAction = Type.createInstance(action, []);
        objectCreator.createInstance(action).returns(expectedAction);
        strategyMap.init();

        var action: StrategyAction = strategyMap.locate(Type.createInstance(handler, []));
        Assert.areEqual(expectedAction, action);
    }
}
