package handler.actions;
import gameentities.HeroInteraction;
import vo.mutable.MutableUnitVO;
import vo.PlayerVO;
import service.PlayerService;
import world.GameObject;
import handler.input.UnitCreated;
import world.GameWorld;
import core.ObjectCreator;
#if !test
import gameentities.InteractiveGameObject;
#end
import geom.Point;
import world.WorldPoint;
import error.Logger;
class UnitCreatedAction implements StrategyAction {

    @inject
    public var logger: Logger;
    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var gameWorld: GameWorld;
    @inject
    public var playerService: PlayerService;
    @inject
    public var heroInteraction: HeroInteraction;

    private var currentPlayer: PlayerVO;

    public function new() {
    }

    public function init():Void {
        playerService.getCurrentPlayer(function(p: PlayerVO): Void {
            currentPlayer = p;
        });
    }

    public function dispose():Void {
    }

    public function execute(handler:IOHandler):Void {
        var unitCreated: UnitCreated = cast handler;

        if(unitCreated.unitType > 2) {
            trace("cmd id " + unitCreated.cmdId);
            trace("player id " + unitCreated.playerId);
            trace("unit id " + unitCreated.unitId);
            trace("unit type " + unitCreated.unitType);
            trace("pos x " + unitCreated.posX);
            trace("pos z " + unitCreated.posZ);
            Console.assert(unitCreated.unitType < 4, "unit type does not exist");
        }
        trace("unitCreated " + unitCreated.unitId);
        var unit: GameObject = createUnit(unitCreated.unitId, unitCreated.unitType);

        var unitVO: MutableUnitVO = objectCreator.createInstance(MutableUnitVO);
        unitVO.id = unitCreated.unitId;
        unitVO.unitType = unitCreated.unitType;

        if(currentPlayer.id == unitCreated.playerId) {
            currentPlayer.units.set(unitVO.id, unitVO);
        }

        var worldPoint: WorldPoint = objectCreator.createInstance(WorldPoint);
        worldPoint.x = unitCreated.posX;
        worldPoint.z = unitCreated.posZ;
        gameWorld.addGameObject(unit, worldPoint);

        heroInteraction.assignUnit(unit);
    }

    public function createUnit(unitId: Int, unitType: Int): GameObject {
        #if !test
        var unit: InteractiveGameObject = objectCreator.createInstance(InteractiveGameObject);
        unit.id = unitId + "";
        unit.type = unitType + "";

        return unit;
        #else
        return null;
        #end
    }

}
