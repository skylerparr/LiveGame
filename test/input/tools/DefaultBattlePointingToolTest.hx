package input.tools;

import world.two.WorldPoint2D;
import mocks.MockGameObject;
import mocks.MockHeroInteraction;
import mocks.MockGameWorld;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class DefaultBattlePointingToolTest {

    private var battleTool: DefaultBattlePointingTool;
    private var gameWorld: MockGameWorld;
    private var heroInteraction: MockHeroInteraction;
    private var pointerEvent: PointerEvent;

    @Before
    public function setup():Void {
        gameWorld = mock(MockGameWorld);
        heroInteraction = mock(MockHeroInteraction);

        pointerEvent = new PointerEvent();

        battleTool = new DefaultBattlePointingTool();
        battleTool.gameWorld = gameWorld;
        battleTool.heroInteraction = heroInteraction;
        battleTool.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldAssignSquadOnClick(): Void {
        pointerEvent.screenX = 423;
        pointerEvent.screenX = 225;

        var gameObject: MockGameObject = mock(MockGameObject);
        var wp = new WorldPoint2D();
        gameWorld.screenToWorld(cast isNotNull).returns(wp);
        gameWorld.getItemAt(wp).returns(gameObject);

        battleTool.onPointerClick(pointerEvent);

        Assert.areEqual(gameObject, battleTool.currentSelectedGameObject);
    }

    @Test
    public function shouldMoveSquadOnLeftClick(): Void {
        var gameObject: MockGameObject = mock(MockGameObject);
        battleTool.currentSelectedGameObject = gameObject;

        var wp = new WorldPoint2D();
        gameWorld.screenToWorld(cast isNotNull).returns(wp);
        battleTool.onPointerRightClick(pointerEvent);

        heroInteraction.moveSquad(gameObject, wp).verify();
    }

    @Test
    public function shouldNotMoveSquadIfNotUnitIsSelected(): Void {
        var wp = new WorldPoint2D();
        gameWorld.screenToWorld(cast isNotNull).returns(wp);
        battleTool.onPointerRightClick(pointerEvent);

        heroInteraction.moveSquad(cast any, wp).verify(0);
    }
}