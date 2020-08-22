package game.vo;
import world.GameObject;
interface UnitMovement extends GameObject {
  var speed: Float;
  var targetX: Float;
  var targetZ: Float;
  var startTime: UInt;
  var time: Int;
}
