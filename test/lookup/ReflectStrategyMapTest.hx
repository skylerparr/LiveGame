package lookup;

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
        expectedAction = mock(PlayerConnectedAction);
        objectCreator.createInstance(PlayerConnectedAction).returns(expectedAction);
        strategyMap.init();

        var action: StrategyAction = strategyMap.locate(new PlayerConnected());
        Assert.areEqual(expectedAction, action);
    }

    @Test
    public function shouldGetUnitCreatedAction(): Void {
        expectedAction = mock(UnitCreatedAction);
        objectCreator.createInstance(UnitCreatedAction).returns(expectedAction);
        strategyMap.init();

        var action: StrategyAction = strategyMap.locate(new UnitCreated());
        Assert.areEqual(expectedAction, action);
    }

    @Test
    public function shouldGetUnitMoveConnectedAction(): Void {
        expectedAction = mock(UnitMoveAction);
        objectCreator.createInstance(UnitMoveAction).returns(expectedAction);
        strategyMap.init();

        var action: StrategyAction = strategyMap.locate(new UnitMove());
        Assert.areEqual(expectedAction, action);
    }

    @Test
    public function shouldReturnNullIfStrategyIsNotFound(): Void {
        strategyMap.init();

        var action: StrategyAction = strategyMap.locate(new PlayerConnect());
        Assert.isNull(action);
    }
}
