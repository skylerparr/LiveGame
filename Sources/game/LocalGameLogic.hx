package game;
import game.vo.UnitMovement;
import game.vo.HeroVO;
import world.GameObject;
import world.two.WorldPoint2D;
import geom.Point;
import handler.input.UnitMove;
import handler.IOHandler;
import handler.actions.UnitMoveAction;
import handler.actions.HeroCreatedAction;
import handler.actions.PlayerConnectedAction;
import core.ObjectCreator;
import handler.input.HeroCreated;
import handler.StrategyAction;
import handler.input.PlayerConnected;
import util.Timer;
class LocalGameLogic implements GameLogic {
  @inject
  public var objectCreator: ObjectCreator;

  private static var pointA: Point = new Point();
  private static var pointB: Point = new Point();

  private var unitMap: Map<String, UnitMovement>;

  public function new() {
  }

  public function init():Void {
    unitMap = new Map<String, UnitMovement>();
  }

  public function dispose():Void {
  }

  public function playerConnect(playerId:UInt):Void {
    var playerConnected: PlayerConnected = objectCreator.createInstance(PlayerConnected);
    playerConnected.identifier = playerId;
    playerConnected.playerId = playerId;

    var action: StrategyAction = objectCreator.createInstance(PlayerConnectedAction);
    action.execute(playerConnected);

    var unitHeroCreated: HeroCreated = objectCreator.createInstance(HeroCreated);
    unitHeroCreated.playerId = playerId;
    unitHeroCreated.unitId = 1;
    unitHeroCreated.unitType = 1;
    unitHeroCreated.posX = 250;
    unitHeroCreated.posZ = 250;

    var hero: HeroVO = objectCreator.createInstance(HeroVO);
    hero.playerId = playerId;
    hero.id = unitHeroCreated.unitId + "";
    hero.unitType = unitHeroCreated.unitType;
    hero.speed = 2.5;
    hero.x = unitHeroCreated.posX;
    hero.z = unitHeroCreated.posZ;
    unitMap.set(hero.id, hero);

    var action: StrategyAction = objectCreator.createInstance(HeroCreatedAction);
    action.execute(unitHeroCreated);
  }

  public function moveUnitTo(unitId:UInt, posX:Int, posZ:Int):Void {
    var unit: UnitMovement = unitMap.get(unitId + "");
    if(unit == null) {
      trace('unit ${unitId} is null');
      return;
    }

    pointA.x = unit.x;
    pointA.y = unit.z;
    pointB.x = posX;
    pointB.y = posZ;

    var stamp: UInt = Timer.now();
    if(unit.time != 0) {
      var diff: Int = stamp - unit.startTime;
      var percentComplete: Float = diff / unit.time;

      unit.x = unit.x + ((unit.targetX - unit.x) * percentComplete);
      unit.z = unit.z + ((unit.targetZ - unit.z) * percentComplete);

      pointA.x = unit.x;
      pointA.y = unit.z;
    }
    var distance: Float = Point.distance(pointA, pointB);
    var time: Int = Std.int(distance * unit.speed);
    unit.time = time;
    unit.startTime = stamp;

    if(time < 1000) {
      unit.targetX = unit.x;
      unit.targetZ = unit.z;
    } else {
      unit.targetX = posX;
      unit.targetZ = posZ;
    }

    var handler: UnitMove = objectCreator.createInstance(UnitMove);
    handler.unitId = unitId;
    handler.posX = unit.targetX;
    handler.posZ = unit.targetZ;
    handler.time = unit.time;

    var action: StrategyAction = objectCreator.createInstance(UnitMoveAction);
    action.execute(handler);
  }
}
