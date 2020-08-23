package game;

import vo.UnitVO;
import vo.PlayerVO;
import vo.mutable.MutablePlayerVO;
import massive.munit.Assert;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class SinglePlayerInteractionTest {
	private var playerInteraction: SinglePlayerInteraction;

  @Before
  public function setup() {
    playerInteraction = new SinglePlayerInteraction();
    playerInteraction.init();
  }

  @After
  public function tearDown() {
    playerInteraction = null;
  }

  @Test
  public function shouldLoadPlayer(): Void {
    var loaded: Bool = false;
    playerInteraction.loadPlayer(1, function(p: Null<PlayerVO>): Void {
      loaded = true;
      Assert.areEqual(p.id, 1);
      Assert.isNotNull(p.hero);
      Assert.areEqual(p.hero.player, p);
      Assert.areEqual(p.hero.unitType, 1);
      Assert.areNotEqual(p.hero.id, 0);
    });
    Assert.isTrue(loaded);
  }

  @Test
  public function shouldReturnNullIfPlayerIsNotFound(): Void {
    var loaded: Bool = false;
    playerInteraction.loadPlayer(10, function(p: Null<PlayerVO>): Void {
      loaded = true;
      Assert.isNull(p);
    });
    Assert.isTrue(loaded);
  }

  @Test
  public function shouldCreateUnitFromUnitType(): Void {
    var loaded: Bool = false;
    createUnit(function(unitVO: UnitVO) {
      loaded = true;
      Assert.isNotNull(unitVO);
    });
    Assert.isTrue(loaded);
  }

  @:async
  private function createUnit():UnitVO {
    var playerVO: PlayerVO = @await playerInteraction.loadPlayer(1);
    var unitVO: UnitVO = @await playerInteraction.createUnit(playerVO, 1);
    Assert.areEqual(unitVO.unitType, 1);
    Assert.areEqual(unitVO.player, playerVO);
    Assert.isNotNull(unitVO.id);
    Assert.areEqual(playerVO.units.get(unitVO.id), unitVO);
    return unitVO;
  }

  @Test
  public function shouldDispose(): Void {
    playerInteraction.dispose();

    Assert.isNull(playerInteraction.playerVO);
  }
  
}