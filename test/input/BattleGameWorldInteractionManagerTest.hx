package input;

import mocks.MockPointingTool;
import mocks.MockDisplayNodeContainer;
import mocks.MockGameInputTools;
import display.DisplayNodeContainer;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class BattleGameWorldInteractionManagerTest {

    private var interactionManager: BattleGameWorldInteractionManager;
    private var gameInputTools: MockGameInputTools;
    private var container: MockDisplayNodeContainer;
    private var currentTool: MockPointingTool;

    @Before
    public function setup():Void {
        gameInputTools = mock(MockGameInputTools);
        container = mock(MockDisplayNodeContainer);
        currentTool = mock(MockPointingTool);

        gameInputTools.get_currentTool().returns(currentTool);

        interactionManager = new BattleGameWorldInteractionManager();
        interactionManager.gameInputTools = gameInputTools;
        interactionManager.init();

        interactionManager.interactionContainer = container;
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldRegisterAllPointerEvents(): Void {
        container.registerPointerEvent(PointerEventType.POINTER_1_CLICK, cast isNotNull).verify();
        container.registerPointerEvent(PointerEventType.POINTER_1_UP, cast isNotNull).verify();
        container.registerPointerEvent(PointerEventType.POINTER_1_DOWN, cast isNotNull).verify();
        container.registerPointerEvent(PointerEventType.POINTER_2_CLICK, cast isNotNull).verify();
        container.registerPointerEvent(PointerEventType.POINTER_2_UP, cast isNotNull).verify();
        container.registerPointerEvent(PointerEventType.POINTER_2_DOWN, cast isNotNull).verify();
        container.registerPointerEvent(PointerEventType.POINTER_3_CLICK, cast isNotNull).verify();
        container.registerPointerEvent(PointerEventType.POINTER_3_UP, cast isNotNull).verify();
        container.registerPointerEvent(PointerEventType.POINTER_3_DOWN, cast isNotNull).verify();
        container.registerPointerEvent(PointerEventType.POINTER_1_DOUBLE_CLICK, cast isNotNull).verify();
        container.registerPointerEvent(PointerEventType.ZOOM, cast isNotNull).verify();
        container.registerPointerEvent(PointerEventType.POINTER_MOVE, cast isNotNull).verify();
    }

    @Test
    public function shouldUnRegisterAllEventsOnPreviousContainerIfReassigned(): Void {
        var newContainer: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        interactionManager.interactionContainer = newContainer;

        container.unRegisterPointerEvent(PointerEventType.POINTER_1_CLICK, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_1_UP, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_1_DOWN, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_2_CLICK, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_2_UP, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_2_DOWN, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_3_CLICK, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_3_UP, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_3_DOWN, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_1_DOUBLE_CLICK, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.ZOOM, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_MOVE, cast isNotNull).verify();
    }

    @Test
    public function shouldNotUnRegisterAllEventsIfHasNeverBeenAssigned(): Void {
        container.unRegisterPointerEvent(PointerEventType.POINTER_1_CLICK, cast isNotNull).verify(0);
        container.unRegisterPointerEvent(PointerEventType.POINTER_1_UP, cast isNotNull).verify(0);
        container.unRegisterPointerEvent(PointerEventType.POINTER_1_DOWN, cast isNotNull).verify(0);
        container.unRegisterPointerEvent(PointerEventType.POINTER_2_CLICK, cast isNotNull).verify(0);
        container.unRegisterPointerEvent(PointerEventType.POINTER_2_UP, cast isNotNull).verify(0);
        container.unRegisterPointerEvent(PointerEventType.POINTER_2_DOWN, cast isNotNull).verify(0);
        container.unRegisterPointerEvent(PointerEventType.POINTER_3_CLICK, cast isNotNull).verify(0);
        container.unRegisterPointerEvent(PointerEventType.POINTER_3_UP, cast isNotNull).verify(0);
        container.unRegisterPointerEvent(PointerEventType.POINTER_3_DOWN, cast isNotNull).verify(0);
        container.unRegisterPointerEvent(PointerEventType.POINTER_1_DOUBLE_CLICK, cast isNotNull).verify(0);
        container.unRegisterPointerEvent(PointerEventType.ZOOM, cast isNotNull).verify(0);
        container.unRegisterPointerEvent(PointerEventType.POINTER_MOVE, cast isNotNull).verify(0);
    }

    @Test
    public function shouldPassEventToCurrentGameTool(): Void {
        var newContainer: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        var pe: PointerEvent = new PointerEvent();

        simulateEvent(newContainer, PointerEventType.POINTER_1_CLICK, pe);
        currentTool.onPointerClick(pe).verify();
        simulateEvent(newContainer, PointerEventType.POINTER_1_UP, pe);
        currentTool.onPointerUp(pe).verify();
        simulateEvent(newContainer, PointerEventType.POINTER_1_DOWN, pe);
        currentTool.onPointerDown(pe).verify();
        simulateEvent(newContainer, PointerEventType.POINTER_2_CLICK, pe);
        currentTool.onPointerRightClick(pe).verify();
        simulateEvent(newContainer, PointerEventType.POINTER_2_UP, pe);
        currentTool.onPointerRightUp(pe).verify();
        simulateEvent(newContainer, PointerEventType.POINTER_2_DOWN, pe);
        currentTool.onPointerRightDown(pe).verify();
        simulateEvent(newContainer, PointerEventType.POINTER_3_CLICK, pe);
        currentTool.onPointerMiddleClick(pe).verify();
        simulateEvent(newContainer, PointerEventType.POINTER_3_UP, pe);
        currentTool.onPointerMiddleUp(pe).verify();
        simulateEvent(newContainer, PointerEventType.POINTER_3_DOWN, pe);
        currentTool.onPointerMiddleDown(pe).verify();
        simulateEvent(newContainer, PointerEventType.POINTER_1_DOUBLE_CLICK, pe);
        currentTool.onPointerDoubleClick(pe).verify();
        simulateEvent(newContainer, PointerEventType.ZOOM, pe);
        currentTool.onScroll(pe).verify();
        simulateEvent(newContainer, PointerEventType.POINTER_MOVE, pe);
        currentTool.onPointerMove(pe).verify();
    }

    @Test
    public function shouldDispose(): Void {
        interactionManager.dispose();

        container.unRegisterPointerEvent(PointerEventType.POINTER_1_CLICK, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_1_UP, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_1_DOWN, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_2_CLICK, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_2_UP, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_2_DOWN, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_3_CLICK, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_3_UP, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_3_DOWN, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_1_DOUBLE_CLICK, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.ZOOM, cast isNotNull).verify();
        container.unRegisterPointerEvent(PointerEventType.POINTER_MOVE, cast isNotNull).verify();

        Assert.isNull(interactionManager.gameInputTools);
        Assert.isNull(interactionManager.interactionContainer);
    }

    private function simulateEvent(newContainer: MockDisplayNodeContainer, eventType: PointerEventType, pe: PointerEvent): Void {
        var handler: PointerEvent->Void = null;
        newContainer.registerPointerEvent(eventType, cast isNotNull).calls(function(args): Void {
            handler = cast args[1];
        });
        interactionManager.interactionContainer = newContainer;
        handler(pe);
    }

}