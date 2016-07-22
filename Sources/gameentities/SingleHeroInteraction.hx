package gameentities;
import world.ViewPort;
import util.Subscriber;
import handler.output.UnitMoveTo;
import handler.StreamHandler;
import core.ObjectCreator;
import world.GameObject;
import world.WorldPoint;
class SingleHeroInteraction implements HeroInteraction {

    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var streamHandler: StreamHandler;
    @inject
    public var viewPortTracker: ViewPortTracker;

    private var heroLocation: WorldPoint;
    private var unitMoveTo: UnitMoveTo;

    @:isVar
    public var hero(get, set):GameObject;

    public function set_hero(value:GameObject) {
        viewPortTracker.trackToGameObject(value);
        return this.hero = value;
    }

    public function get_hero():GameObject {
        return hero;
    }

    public function new() {
    }

    public function init():Void {
        heroLocation = objectCreator.createInstance(WorldPoint);
        unitMoveTo = objectCreator.createInstance(UnitMoveTo);
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
        unitMoveTo.unitId = Std.parseInt(hero.id);
        unitMoveTo.posX = Std.int(worldPoint.x);
        unitMoveTo.posZ = Std.int(worldPoint.z);
        streamHandler.send(unitMoveTo);
    }
}
