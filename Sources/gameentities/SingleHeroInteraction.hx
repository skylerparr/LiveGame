package gameentities;
import collections.UniqueCollection;
import handler.output.MoveSquadTo;
import world.WorldPoint;
import handler.output.UnitCastSpell;
import vo.SpellVO;
import handler.output.UnitMoveTo;
import handler.StreamHandler;
import core.ObjectCreator;
import world.GameObject;
class SingleHeroInteraction implements HeroInteraction {

    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var viewPortTracker: ViewPortTracker;

    public var streamHandler: StreamHandler;
    private var heroLocation: WorldPoint;
    private var unitMoveTo: UnitMoveTo;
    private var unitCastSpell: UnitCastSpell;
    private var moveSquadTo: MoveSquadTo;

    private var unitList: UniqueCollection<GameObject>;

    @:isVar
    public var hero(get, set):GameObject;

    public var units(get, null):List<GameObject>;

    public function set_hero(value:GameObject) {
        viewPortTracker.trackToGameObject(value);
        return this.hero = value;
    }

    public function get_hero():GameObject {
        return hero;
    }

    function get_units():List<GameObject> {
        return unitList.asList();
    }

    public function new() {
    }

    public function init():Void {
        heroLocation = objectCreator.createInstance(WorldPoint);
        unitMoveTo = objectCreator.createInstance(UnitMoveTo);
        unitCastSpell = objectCreator.createInstance(UnitCastSpell);
        moveSquadTo = objectCreator.createInstance(MoveSquadTo);
        unitList = new UniqueCollection<GameObject>();
    }

    public function dispose():Void {
    }

    public function getCurrentLocation():WorldPoint {
        if(hero == null) {
            return null;
        }
        heroLocation.x = hero.x;
        heroLocation.z = hero.z;
        return heroLocation;
    }

    public function moveTo(worldPoint:WorldPoint):Void {
        if(hero.busy) {
            return;
        }
        unitMoveTo.unitId = Std.parseInt(hero.id);
        unitMoveTo.posX = Std.int(worldPoint.x);
        unitMoveTo.posZ = Std.int(worldPoint.z);
        streamHandler.send(unitMoveTo);
    }

    public function castSpell(targetUnit: GameObject, targetLocation: WorldPoint, spell:SpellVO):Void {
        if(hero.busy) {
            return;
        }
        unitCastSpell.unitId = Std.parseInt(hero.id);
        unitCastSpell.spellId = spell.id;
        if(targetUnit != null) {
            unitCastSpell.targetUnitId = Std.parseInt(targetUnit.id);
        } else if(targetLocation != null) {
            unitCastSpell.targetPosX = Std.int(targetLocation.x);
            unitCastSpell.targetPosZ = Std.int(targetLocation.z);
        }
        streamHandler.send(unitCastSpell);
    }

    public function moveSquad(targetUnit:GameObject, targetLocation:WorldPoint):Void {
        if(hero.busy) {
            return;
        }
        moveSquadTo.unitId = Std.parseInt(targetUnit.id);
        moveSquadTo.posX = Std.int(targetLocation.x);
        moveSquadTo.posZ = Std.int(targetLocation.z);

        streamHandler.send(moveSquadTo);
    }

    public function assignUnit(targetUnit:GameObject):Void {
        if(targetUnit != hero) {
            unitList.add(targetUnit);
        }
    }

}
