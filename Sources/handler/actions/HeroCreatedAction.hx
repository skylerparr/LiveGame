package handler.actions;
import world.WorldPoint;
import geom.Point;
import vo.MutableUnitVO;
import vo.MutableUnitVO;
import world.GameObject;
import handler.input.UnitCreated;
import world.GameWorld;
import core.ObjectCreator;
import gameentities.HeroInteraction;
import error.Logger;
import service.PlayerService;
import handler.input.PlayerConnected;
import vo.PlayerVO;
import vo.MutablePlayerVO;
#if !test
import gameentities.NecroDisplay;
import gameentities.NecroGameObject;
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
        logger.logDebug("hero created");
        var unitCreated: UnitCreated = cast handler;
        var unit: GameObject = createUnit(unitCreated.unitId, unitCreated.unitType);

        var unitVO: MutableUnitVO = objectCreator.createInstance(MutableUnitVO);
        unitVO.id = unitCreated.unitId;
        unitVO.unitType = unitCreated.unitType;

        if(currentPlayer.id == unitCreated.playerId) {
            currentPlayer.units.set(unitVO.id, unitVO);
            heroInteraction.hero = unit;
        }

        var worldPoint: WorldPoint = gameWorld.screenToWorld(new Point(unitCreated.posX, unitCreated.posY));
        gameWorld.addGameObject(unit, worldPoint);
    }

    public function createUnit(unitId: Int, unitType: Int): GameObject {
        #if !test
        var unit: NecroGameObject = objectCreator.createInstance(NecroGameObject);
        unit.id = unitId + "";

        return unit;
        #else
        return null;
        #end
    }

}
