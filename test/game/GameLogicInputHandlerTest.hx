package game;

import handler.IOHandler;
import handler.StrategyAction;
import handler.StrategyMap;
import massive.munit.Assert;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class GameLogicInputHandlerTest {

	private var gameLogicInput: GameLogicInputHandler;
	private var strategyMap: StrategyMap;

  @Before
  public function setup() {
		strategyMap = mock(StrategyMap);

		gameLogicInput = new GameLogicInputHandler();
		gameLogicInput.strategyMap = strategyMap;

		gameLogicInput.init();
  }

  @After
  public function tearDown() {
		gameLogicInput = null;
  }

	@Test
	public function shouldDispose(): Void {
		gameLogicInput.dispose();

		Assert.isNull(gameLogicInput.strategyMap);
	}

	@Test
	public function shouldFetchTheActionFromTheStategyMapAndInvokeExecute(): Void {
		var action: StrategyAction = mock(StrategyAction);
		var handler: IOHandler = mock(IOHandler);
		strategyMap.locate(handler).returns(action);

		gameLogicInput.input(handler);

		action.execute(handler).verify();
	}
}