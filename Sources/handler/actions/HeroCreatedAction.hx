package handler.actions;
import vo.UnitVO;
import gameentities.BaseGameObject;
import world.WorldPoint;
import geom.Point;
import vo.mutable.MutableUnitVO;
import world.GameObject;
import handler.input.UnitCreated;
import world.GameWorld;
import core.ObjectCreator;
import gameentities.HeroInteraction;
import error.Logger;
import service.PlayerService;
import handler.input.PlayerConnected;
import vo.PlayerVO;
import vo.mutable.MutablePlayerVO;
#if !test
import gameentities.InteractiveGameObject;
#end
class HeroCreatedAction implements StrategyAction {

    @inject
    public var heroInteraction: HeroInteraction;
    @inject
    public var logger: Logger;
    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var gameWorld: GameWorld;
    @inject
    public var playerService: PlayerService;

    public var currentPlayer: PlayerVO;

    public function new() {
    }

    public function init():Void {
        playerService.getCurrentPlayer(function(p: PlayerVO): Void {
            currentPlayer = p;
        });
    }

    public function dispose():Void {
        currentPlayer = null;
        playerService = null;
        gameWorld = null;
        objectCreator = null;
        logger = null;
        heroInteraction = null;
    }

    public function execute(handler:IOHandler):Void {
        logger.logDebug("hero created");
        var unitCreated: UnitCreated = cast handler;
        var unit: GameObject = createUnit(unitCreated.unitId, unitCreated.unitType);

        var unitVO: UnitVO = objectCreator.createInstance(MutableUnitVO);
        unitVO.id = unitCreated.unitId;
        unitVO.unitType = unitCreated.unitType;

        trace(currentPlayer.id, unitCreated.playerId);
        if(currentPlayer.id == unitCreated.playerId) {
            currentPlayer.units.set(unitVO.id, unitVO);
            heroInteraction.hero = unit;
        }

        var worldPoint: WorldPoint = gameWorld.screenToWorld(new Point(unitCreated.posX, unitCreated.posZ));
        gameWorld.addGameObject(unit, worldPoint);
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
