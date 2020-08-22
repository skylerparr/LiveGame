package game.actions;

import handler.output.UnitMoveTo;
import massive.munit.Assert;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class UnitMoveToActionTest {
	private var unitMoveToAction: UnitMoveToAction;
	private var gameLogic: GameLogic;

  @Before
  public function setup() {
		gameLogic = mock(GameLogic);

		unitMoveToAction = new UnitMoveToAction();
		unitMoveToAction.gameLogic = gameLogic;

		unitMoveToAction.init();
  }

  @After
  public function tearDown() {
		unitMoveToAction = null;
  }

	@Test
	public function shouldSendGameLogicUnitMovement(): Void {
		var handler: UnitMoveTo = new UnitMoveTo();
		handler.unitId = 1;
		handler.posX = 321;
		handler.posZ = 21;
		unitMoveToAction.execute(handler);

		gameLogic.moveUnitTo(1, 321, 21).verify();
	}
}