package game;
import handler.actions.UnitCreatedAction;
import vo.PlayerVO;
import vo.PlayerVO;
import handler.input.UnitCreated;
import handler.actions.UnitCastedSpellAction;
import handler.input.UnitCastedSpell;
import constants.EventNames;
import util.Subscriber;
import handler.actions.UnitCastingSpellAction;
import handler.input.UnitCastingSpell;
import vo.mutable.MutableHeroVO;
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

  @inject
  public var subscriber: Subscriber;

  private static var pointA: Point = new Point();
  private static var pointB: Point = new Point();

  private var unitMap: Map<String, UnitMovement>;

  private var functionsToInvoke: List<Dynamic>;
  private var playerId: Int;

  public function new() {
  }

  public function init():Void {
    unitMap = new Map<String, UnitMovement>();
    functionsToInvoke = new List<Dynamic>();

    subscriber.subscribe(EventNames.ENTER_GAME_LOOP, onUpdate);
  }

  public function dispose():Void {
  }

  public function onUpdate():Void {
    do {
      var fun: Dynamic = functionsToInvoke.pop();
      if(fun == null) {
        return;
      }
      fun();
    } while(true);
  }

  public function playerConnect(playerId:UInt):Void {
    var fun: Void->Void = function() {
      this.playerId = playerId;

      var playerConnected: PlayerConnected = objectCreator.createInstance(PlayerConnected);
      playerConnected.identifier = playerId;
      playerConnected.playerId = playerId;

      var action: StrategyAction = objectCreator.createInstance(PlayerConnectedAction);
      action.execute(playerConnected);

      var unitHeroCreated: HeroCreated = objectCreator.createInstance(HeroCreated);
      unitHeroCreated.playerId = playerId;
      unitHeroCreated.unitId = 1;
      unitHeroCreated.unitType = 1;
      unitHeroCreated.posX = 1250;
      unitHeroCreated.posZ = 1250;

      var hero: MutableHeroVO = objectCreator.createInstance(MutableHeroVO);
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
    functionsToInvoke.add(fun);
  }

  public function moveUnitTo(unitId:UInt, posX:Int, posZ:Int):Void {
    var unit: UnitMovement = unitMap.get(unitId + "");
    if(unit == null) {
      trace('unit ${unitId} is null');
      return;
    }
    var fun = function() {
      pointA = getUnitLocation(unit);

      pointB.x = posX;
      pointB.y = posZ;

      var distance: Float = Point.distance(pointA, pointB);
      var time: Int = Std.int(distance * unit.speed);
      unit.time = time;
      unit.startTime = Timer.now();

      // if the time is less than 1 second, the player probably was meant to be stopped
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
    functionsToInvoke.add(fun);
  }

  public function unitCastSpell(unitId:Int, spellId:Int, targetUnitId:Int, targetPosX:Int, targetPosZ:Int):Void {
    var unit: UnitMovement = unitMap.get(unitId + "");
    if(unit == null) {
      trace('unit ${unitId} is null');
      return;
    }
    var point: Point = getUnitLocation(unit);
    unit.time = 0;
    unit.targetX = point.x;
    unit.targetZ = point.y;
    moveUnitTo(unitId, Std.int(point.x), Std.int(point.y));

    var castSpellFun = function() {
      var castingSpell: UnitCastingSpell = objectCreator.createInstance(UnitCastingSpell);
      castingSpell.unitId = 1;
      castingSpell.spellId = 1;
      castingSpell.posX = unit.x + 40;
      castingSpell.posZ = unit.z;

      var action: StrategyAction = objectCreator.createInstance(UnitCastingSpellAction);
      action.execute(castingSpell);
    }
    functionsToInvoke.add(castSpellFun);

    util.Timer.setTimeout(function() {
      castSpellFun = function() {
        var spellCasted: UnitCastedSpell = objectCreator.createInstance(UnitCastedSpell);
        spellCasted.unitId = 1;
        spellCasted.spellId = 1;
        spellCasted.posX = unit.x + 40;
        spellCasted.posZ = unit.z;

        var action: StrategyAction = objectCreator.createInstance(UnitCastedSpellAction);
        action.execute(spellCasted);

        var unitCreated: UnitCreated = objectCreator.createInstance(UnitCreated);
        unitCreated.playerId = this.playerId;
        unitCreated.unitType = 2;
        unitCreated.unitId = Std.int(Math.random() * 0xffffff);
        unitCreated.posX = Std.int(unit.x) + 40;
        unitCreated.posZ = Std.int(unit.z);

        var action: StrategyAction = objectCreator.createInstance(UnitCreatedAction);
        action.execute(unitCreated);
      }
      functionsToInvoke.add(castSpellFun);
    }, 1000);
  }

  private inline function getUnitLocation(unit: UnitMovement): Point {
    var retVal: Point = new Point();
    var stamp: UInt = Timer.now();
    if(unit.time != 0) {
      var diff: Int = stamp - unit.startTime;
      var percentComplete: Float = diff / unit.time;

      unit.x = unit.x + ((unit.targetX - unit.x) * percentComplete);
      unit.z = unit.z + ((unit.targetZ - unit.z) * percentComplete);

      retVal.x = unit.x;
      retVal.y = unit.z;
    } else {
      retVal.x = unit.x;
      retVal.y = unit.z;
    }
    return retVal;
  }

}
