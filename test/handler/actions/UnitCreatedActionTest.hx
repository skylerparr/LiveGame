package handler.actions;

import vo.UnitVO;
import world.WorldPoint;
import world.two.WorldPoint2D;
import vo.mutable.MutableUnitVO;
import gameentities.BaseGameObject;
import vo.mutable.MutablePlayerVO;
import handler.input.UnitCreated;
import vo.PlayerVO;
import gameentities.HeroInteraction;
import service.PlayerService;
import world.GameWorldDisplay;
import core.ObjectCreator;
import error.Logger;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class UnitCreatedActionTest {

    private var unitCreatedAction: UnitCreatedAction;
    private var logger: Logger;
    private var objectCreator: ObjectCreator;
    private var gameWorld: GameWorldDisplay;
    private var playerService: PlayerService;
    private var heroInteraction: HeroInteraction;
    private var currentPlayer: MutablePlayerVO;
    private var unitCreated: UnitCreated;
    private var gameObject: BaseGameObject;
    private var unitVO: MutableUnitVO;
    private var worldPoint: WorldPoint2D;
    private var units: Map<UInt, UnitVO>;

    @Before
    public function setup():Void {
        logger = mock(Logger);
        objectCreator = mock(ObjectCreator);
        gameWorld = mock(GameWorldDisplay);
        playerService = mock(PlayerService);
        heroInteraction = mock(HeroInteraction);
        currentPlayer = mock(MutablePlayerVO);
        unitVO = new MutableUnitVO();
        gameObject = mock(BaseGameObject);

        worldPoint = new WorldPoint2D();

        unitCreated = new UnitCreated();
        unitCreated.playerId = 32;
        unitCreated.unitId = 33;
        unitCreated.unitType = 34;
        unitCreated.posX = 100;
        unitCreated.posZ = 200;

        units = new Map<UInt, UnitVO>();
        currentPlayer.get_id().returns(5);
        currentPlayer.get_units().returns(units);

        objectCreator.createInstance(cast isNotNull).calls(function(args: Array<Dynamic>): Dynamic {
            if(args[0] == BaseGameObject) {
                return gameObject;
            } else if(args[0] == MutableUnitVO) {
                return unitVO;
            } else if(args[0] == WorldPoint) {
                return worldPoint;
            }
            return null;
        });

        playerService.getCurrentPlayer(cast isNotNull).calls(function(args: Array<Dynamic>): Void {
            args[0](currentPlayer);
        });

        unitCreatedAction = new UnitCreatedAction();
        unitCreatedAction.logger = logger;
        unitCreatedAction.objectCreator = objectCreator;
        unitCreatedAction.gameWorld = gameWorld;
        unitCreatedAction.playerService = playerService;
        unitCreatedAction.heroInteraction = heroInteraction;
        unitCreatedAction.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldCreateUnitAndAddItToTheGameWorld(): Void {
        unitCreatedAction.execute(unitCreated);

        gameObject.set_id(33).verify();
        gameObject.set_type("34").verify();

        Assert.areEqual(33, unitVO.id);
        Assert.areEqual(34, unitVO.unitType);

        gameWorld.addGameObject(gameObject, worldPoint).verify();
    }

    @Test
    public function shouldAddUnitToPlayerIfOwnedByPlayer(): Void {
        unitCreated.playerId = 5;
        unitCreatedAction.execute(unitCreated);

        Assert.areEqual(unitVO, units.get(33));
    }

    @Test
    public function shouldAssignUnitToHeroInteraction(): Void {
        unitCreatedAction.execute(unitCreated);
        heroInteraction.assignUnit(gameObject).verify();
    }

    @Test
    public function shouldDispose(): Void {
        unitCreatedAction.execute(unitCreated);
        unitCreatedAction.dispose();
        Assert.isNull(unitCreatedAction.logger);
        Assert.isNull(unitCreatedAction.objectCreator);
        Assert.isNull(unitCreatedAction.gameWorld);
        Assert.isNull(unitCreatedAction.playerService);
        Assert.isNull(unitCreatedAction.heroInteraction);
        Assert.isNull(unitCreatedAction.currentPlayer);
    }
}