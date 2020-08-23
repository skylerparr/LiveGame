package handler.actions;

import world.GameObject;
import error.Logger;
import world.two.WorldPoint2D;
import handler.input.UnitMove;
import core.ObjectCreator;
import gameentities.UnitInteractionManager;
import world.GameWorldDisplay;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class UnitMoveActionTest {

    private var unitMoveAction: UnitMoveAction;
    private var logger: Logger;
    private var gameWorld: GameWorldDisplay;
    private var interactionManger: UnitInteractionManager;
    private var objectCreator: ObjectCreator;
    private var handler: UnitMove;
    private var worldPoint: WorldPoint2D;

    @Before
    public function setup():Void {
        logger = mock(Logger);
        gameWorld = mock(GameWorldDisplay);
        interactionManger = mock(UnitInteractionManager);
        objectCreator = mock(ObjectCreator);

        worldPoint = new WorldPoint2D();
        objectCreator.createInstance(cast isNotNull).returns(worldPoint);

        handler = new UnitMove();
        handler.unitId = 342;
        handler.posX = 100;
        handler.posZ = 200;
        handler.time = 2000;

        unitMoveAction = new UnitMoveAction();
        unitMoveAction.logger = logger;
        unitMoveAction.gameWorld = gameWorld;
        unitMoveAction.interactionManager = interactionManger;
        unitMoveAction.objectCreator = objectCreator;
        unitMoveAction.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldTranslateGameObject(): Void {
        var unit: GameObject = mock(GameObject);
        gameWorld.getGameObjectById("342").returns(unit);
        unitMoveAction.execute(handler);
        Assert.areEqual(100, worldPoint.x);
        Assert.areEqual(200, worldPoint.z);
        interactionManger.translateGameObjectTo(unit, worldPoint, 2000).verify();
    }

    @Test
    public function shouldLogWarningIfUnitNotFound(): Void {
        gameWorld.getGameObjectById(cast isNotNull).returns(null);
        unitMoveAction.execute(handler);
        logger.logWarning(cast isNotNull).verify();
    }

    @Test
    public function shouldDispose(): Void {
        var unit: GameObject = mock(GameObject);
        unitMoveAction.execute(handler);
        unitMoveAction.dispose();

        Assert.isNull(unitMoveAction.logger);
        Assert.isNull(unitMoveAction.gameWorld);
        Assert.isNull(unitMoveAction.interactionManager);
        Assert.isNull(unitMoveAction.objectCreator);
    }
}