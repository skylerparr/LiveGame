package game.actions;

import handler.output.UnitCastSpell;
import massive.munit.Assert;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class UnitCastSpellActionTest {

	private var unitCastSpellAction: UnitCastSpellAction;
	private var gameLogic: GameLogic;

  @Before
  public function setup() {
		gameLogic = mock(GameLogic);
		unitCastSpellAction = new UnitCastSpellAction();
		unitCastSpellAction.gameLogic = gameLogic;

		unitCastSpellAction.init();
  }

  @After
  public function tearDown() {
		unitCastSpellAction = null;
  }

	@Test
	public function shouldDispose(): Void {
		unitCastSpellAction.dispose();
		Assert.isNull(unitCastSpellAction.gameLogic);
	}

	@Test
	public function shouldPassUnitCastSpellToGameLogic(): Void {
		var handler: UnitCastSpell = new UnitCastSpell();
		handler.unitId = 3289;
		handler.spellId = 23;
		handler.targetUnitId = 2283;
		handler.targetPosX = 2839;
		handler.targetPosZ = 382;

		unitCastSpellAction.execute(handler);
		gameLogic.unitCastSpell(3289, 23, 2283, 2839, 382).verify();
	}
}