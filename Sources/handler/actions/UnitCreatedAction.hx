package handler.actions;
import vo.MutableUnitVO;
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
        logger.logDebug("unit created");
        var unitCreated: UnitCreated = cast handler;
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
