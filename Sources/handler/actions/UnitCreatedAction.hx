package handler.actions;
import gameentities.BaseGameObject;
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

    public var currentPlayer: PlayerVO;

    public function new() {
    }

    public function init():Void {
        playerService.getCurrentPlayer(function(p: PlayerVO): Void {
            currentPlayer = p;
        });
    }

    public function dispose():Void {
        logger = null;
        objectCreator = null;
        gameWorld = null;
        playerService = null;
        heroInteraction = null;
        currentPlayer = null;
    }

    public function execute(handler:IOHandler):Void {
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

        heroInteraction.assignUnit(unit);
    }

    public function createUnit(unitId: Int, unitType: Int): GameObject {
        #if !test
        var unit: InteractiveGameObject = objectCreator.createInstance(InteractiveGameObject);
        #else
        var unit: BaseGameObject = objectCreator.createInstance(BaseGameObject);
        #end
        unit.id = unitId + "";
        unit.type = unitType + "";
        return unit;
    }

}
