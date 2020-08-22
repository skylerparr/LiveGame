package game.vo;
import world.GameObject;
import gameentities.BaseGameObject;
class HeroVO extends BaseGameObject implements UnitMovement {
  public var playerId: Int;
  public var unitType: Int;
  public var units: Array<GameObject>;

  public var speed: Float;
  public var targetX: Float;
  public var targetZ: Float;
  public var startTime: UInt;
  public var time: Int;

  public function new() {
    super();
    units = [];
  }
}
