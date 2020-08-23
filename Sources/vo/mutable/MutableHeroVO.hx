package vo.mutable;
import game.UnitMovement;
import collections.UniqueCollection;
import world.GameObject;
import gameentities.BaseGameObject;
@IgnoreCover
class MutableHeroVO extends BaseGameObject implements UnitMovement {
  public var playerId: Int;
  public var unitType: Int;
  public var units: UniqueCollection<GameObject>;

  public var speed: Float;
  public var targetX: Float;
  public var targetZ: Float;
  public var startTime: UInt;
  public var time: Int;

  public function new() {
    super();
    units = new UniqueCollection<GameObject>();
  }
}
