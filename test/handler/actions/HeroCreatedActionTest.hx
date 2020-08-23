package handler.actions;

import vo.mutable.MutablePlayerVO;
import world.two.WorldPoint2D;
import mocks.MockHeroInteraction;
import vo.mutable.MutableUnitVO;
import vo.UnitVO;
import handler.input.HeroCreated;
import gameentities.BaseGameObject;
import vo.PlayerVO;
import service.PlayerService;
import world.GameWorldDisplay;
import core.ObjectCreator;
import error.Logger;
import gameentities.HeroInteraction;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class HeroCreatedActionTest {

    private var heroCreated: HeroCreatedAction;
    private var heroInteraction: MockHeroInteraction;
    private var logger: Logger;
    private var objectCreator: ObjectCreator;
    private var gameWorld: GameWorldDisplay;
    private var playerService: PlayerService;
    private var playerVO: MutablePlayerVO;
    private var baseGameObject: BaseGameObject;
    private var heroCreatedHandler: HeroCreated;
    private var unitVO: MutableUnitVO;
    private var units: Map<Int, UnitVO>;

    @Before
    public function setup():Void {
        heroInteraction = mock(MockHeroInteraction);
        logger = mock(Logger);
        objectCreator = mock(ObjectCreator);
        gameWorld = mock(GameWorldDisplay);
        playerService = mock(PlayerService);
        playerVO = mock(MutablePlayerVO);
        baseGameObject = mock(BaseGameObject);
        unitVO = mock(MutableUnitVO);
        heroCreatedHandler = new HeroCreated();
        units = new Map<Int, UnitVO>();

        playerService.getCurrentPlayer(cast isNotNull).calls(function(args: Array<Dynamic>): Void {
            args[0](playerVO);
        });

        heroCreated = new HeroCreatedAction();
        heroCreated.logger = logger;
        heroCreated.heroInteraction = heroInteraction;
        heroCreated.objectCreator = objectCreator;
        heroCreated.gameWorld = gameWorld;
        heroCreated.playerService = playerService;
        heroCreated.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldGetPlayerOnInit(): Void {
        Assert.areEqual(playerVO, heroCreated.currentPlayer);
    }

    @Test
    public function shouldCreateHeroUnitAndAddItToTheGameWorld(): Void {
        heroCreatedHandler.playerId = 43;
        setupExec();

        heroCreated.execute(heroCreatedHandler);

        heroInteraction.set_hero(baseGameObject).verify();
        Assert.areEqual(unitVO, units.get(42));
    }

    @Test
    public function shouldNotSetHeroOrUnitsIfPlayerIdsDontMatch(): Void {
        heroCreatedHandler.playerId = 5;
        setupExec();

        heroCreated.execute(heroCreatedHandler);

        heroInteraction.set_hero(baseGameObject).verify(0);
        Assert.isNull(units.get(42));
    }

    @Test
    public function shouldDispose(): Void {
        heroCreated.dispose();

        Assert.isNull(heroCreated.currentPlayer);
        Assert.isNull(heroCreated.logger);
        Assert.isNull(heroCreated.heroInteraction);
        Assert.isNull(heroCreated.objectCreator);
        Assert.isNull(heroCreated.gameWorld);
        Assert.isNull(heroCreated.playerService);
    }

    private inline function setupExec(): Void {
        objectCreator.createInstance(cast isNotNull).calls(function(args: Array<Dynamic>): Dynamic {
            if(args[0] == BaseGameObject) {
                return baseGameObject;
            } else if(args[0] == MutableUnitVO) {
                return unitVO;
            }
            return null;
        });
        heroCreatedHandler.unitId = 42;
        heroCreatedHandler.unitType = 41;
        playerVO.get_id().returns(43);
        playerVO.units.returns(units);
        var wp: WorldPoint2D = new WorldPoint2D();
        gameWorld.screenToWorld(cast isNotNull).returns(wp);

    }
}