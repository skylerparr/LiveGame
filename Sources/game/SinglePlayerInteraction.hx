package game;
import vo.mutable.MutableUnitVO;
import vo.mutable.MutablePlayerVO;
import vo.UnitVO;
import vo.PlayerVO;
class SinglePlayerInteraction implements PlayerInteraction {
  private static inline var PLAYER_ID: Int = 1;
  private static var _id: Int = 0;

  public var playerVO: MutablePlayerVO;

  public function new() {
  }

  public function init():Void {
    playerVO = new MutablePlayerVO();
    playerVO.id = PLAYER_ID;
    playerVO.hero = new MutableUnitVO();
    playerVO.hero.player = playerVO;
    playerVO.hero.unitType = 1;
    playerVO.hero.id = ++_id;
  }

  public function dispose():Void {
    playerVO = null;
  }

  public function loadPlayer(playerId:Int, onComplete:(Null<PlayerVO>) -> Void):Void {
    if(playerId == PLAYER_ID) {
      onComplete(playerVO);
    } else {
      onComplete(null);
    }
  }

  public function createUnit(player:PlayerVO, unitType:Int, onComplete:(Null<UnitVO>) -> Void):Void {
    var unit = new MutableUnitVO();
    unit.player = player;
    unit.id = ++_id;
    unit.unitType = unitType;
    unit.player.units.set(unit.id, unit);
    onComplete(unit);
  }

}
