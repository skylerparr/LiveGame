package game;

import game.actions.UnitCastSpellAction;
import handler.output.UnitCastSpell;
import game.actions.UnitMoveToAction;
import handler.output.UnitMoveTo;
import core.ObjectCreator;
import game.actions.PlayerConnectAction;
import handler.output.PlayerConnect;
import handler.StrategyAction;
import handler.StrategyMap;
import massive.munit.Assert;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class GameLogicStrategyMapTest {

  private var strategyMap: GameLogicStrategyMap;
  private var objectCreator: ObjectCreator;

  @Before
  public function setup() {
    strategyMap = new GameLogicStrategyMap();
    objectCreator = mock(ObjectCreator);
    strategyMap.objectCreator = objectCreator;

    objectCreator.createInstance(PlayerConnectAction).returns(new PlayerConnectAction());
    objectCreator.createInstance(UnitMoveToAction).returns(new UnitMoveToAction());
    objectCreator.createInstance(UnitCastSpellAction).returns(new UnitCastSpellAction());
    strategyMap.init();
  }

  @After
  public function tearDown() {
    strategyMap = null;
  }

  @Test
  public function shouldDispose(): Void {
    strategyMap.dispose();
    Assert.isNull(strategyMap.handlerMap);
    Assert.isNull(strategyMap.objectCreator);
  }

  @Test
  public function shouldGetPlayerConnectAction(): Void {
    var action: StrategyAction = strategyMap.locate(new PlayerConnect());
    Assert.areEqual(Type.getClass(action), PlayerConnectAction);
  }

  @Test
  public function shouldGetUnitMoveToAction(): Void {
    var action: StrategyAction = strategyMap.locate(new UnitMoveTo());
    Assert.areEqual(Type.getClass(action), UnitMoveToAction);
  }

  @Test
  public function shouldGetUnitCastSpellAction(): Void {
    var action: StrategyAction = strategyMap.locate(new UnitCastSpell());
    Assert.areEqual(Type.getClass(action), UnitCastSpellAction);
  }

}