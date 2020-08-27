package game;
import world.WorldEntity;
import world.GameObject;
interface UnitMovement extends WorldEntity {
  var speed: Float;
  var targetX: Float;
  var targetZ: Float;
  var startTime: UInt;
  var time: Int;
}
