package game;

import handler.output.UnitCastSpell;
import handler.output.UnitMoveTo;
import handler.output.PlayerConnect;
import handler.IOHandler;
import massive.munit.Assert;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class GameLogicInputHandlerTest {

	private var gameLogicInput: GameLogicInputHandler;
	private var gameLogic: GameLogic;

  @Before
  public function setup() {
		gameLogic = mock(GameLogic);
		gameLogicInput = new GameLogicInputHandler();
		gameLogicInput.gameLogic = gameLogic;

		gameLogicInput.init();
  }

  @After
  public function tearDown() {
		gameLogicInput = null;
  }

	@Test
	public function shouldDispose(): Void {
		gameLogicInput.dispose();

		Assert.isNull(gameLogicInput.gameLogic);
	}

	@Test
	public function shouldInvokePlayerConnect(): Void {
		var handler: PlayerConnect = new PlayerConnect();
		handler.playerId = 21;

		gameLogicInput.input(handler);

		gameLogic.playerConnect(21).verify();
	}
	
	@Test
	public function shouldInvokeUnitMove(): Void {
		var handler: UnitMoveTo = new UnitMoveTo();
		handler.unitId = 2348;
		handler.posX = 248;
		handler.posZ = 28;

		gameLogicInput.input(handler);

		gameLogic.moveUnitTo(2348, 248, 28).verify();
	}

  @Test
  public function shouldInvokeUnitCastSpell(): Void {
		var handler: UnitCastSpell = new UnitCastSpell();
		handler.unitId = 329;
		handler.spellId = 33;
		handler.targetUnitId = -1;
		handler.targetPosX = 390;
		handler.targetPosZ = 47;

		gameLogicInput.input(handler);

		gameLogic.unitCastSpell(329, 33, -1, 390, 47);
  }
}