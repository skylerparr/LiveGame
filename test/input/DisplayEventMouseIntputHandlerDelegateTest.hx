package input;

import display.DisplayNodeContainer;
import mocks.MockDisplayNodeContainer;
import display.DisplayNode;
import core.ObjectCreator;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class DisplayEventMouseIntputHandlerDelegateTest {

    private var delegate: DisplayEventMouseInputHandlerDelegate;
    private var objectCreator: ObjectCreator;
    private var sourceListener: PointingInputSourceListener;
    private var nodes: List<DisplayNode>;

    @Before
    public function setup():Void {
        objectCreator = mock(ObjectCreator);
        sourceListener = mock(PointingInputSourceListener);
        objectCreator.createInstance(PointerEvent).calls(function(args): PointerEvent {
            return new PointerEvent();
        });

        nodes = new List<DisplayNode>();

        delegate = new DisplayEventMouseInputHandlerDelegate();
        delegate.objectCreator = objectCreator;
        delegate.pointingInputSourceListener = sourceListener;
        delegate.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldLocateTargetDisplayAndPassEventToSourceListener(): Void {
        var display: DisplayNodeContainer = createDisplay(true, false);
        nodes.push(display);

        sourceListener.onPointerDown(cast isNotNull).calls(function(args): Void {
            var pointerEvent: PointerEvent = args[0];
            Assert.areEqual(display, pointerEvent.target);
            Assert.areEqual(10, pointerEvent.screenX);
            Assert.areEqual(20, pointerEvent.screenY);
        });

        delegate.mouseDown(nodes, 0, 10, 20);

        sourceListener.onPointerDown(cast isNotNull).verify();
    }

    private inline function createDisplay(mouseEnabled: Bool, mouseChildren: Bool): DisplayNodeContainer {
        var retVal: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        retVal.get_mouseEnabled().returns(mouseEnabled);
        retVal.get_mouseChildren().returns(mouseChildren);
        return retVal;
    }

//    @Test
//    public function shouldCaptureRightMouseUpAndPassToGameTool(): Void {
//        gameTools.currentTool.returns(currentTool);
//
//        mouseInput.onMouseUp(0, 10, 20);
//
//        currentTool.onPointerUp(pointerEvent).verify();
//        Assert.areEqual(10, pointerEvent.screenX);
//        Assert.areEqual(20, pointerEvent.screenY);
//    }
//
//    @Test
//    public function shouldCaptureClickIfMouseDownThenMouseUp(): Void {
//        gameTools.currentTool.returns(currentTool);
//
//        mouseInput.onMouseDown(0, 10, 20);
//        mouseInput.onMouseUp(0, 10, 20);
//
//        currentTool.onPointerClick(pointerEvent).verify();
//        Assert.areEqual(10, pointerEvent.screenX);
//        Assert.areEqual(20, pointerEvent.screenY);
//    }
//
//    @Test
//    public function shouldNotCaptureClickIfMouseDownThenMoveMoreThan3PixelsThenMouseUp(): Void {
//        gameTools.currentTool.returns(currentTool);
//
//        mouseInput.onMouseDown(0, 10, 20);
//        mouseInput.onMouseMove(0, 0, 10, 16);
//        mouseInput.onMouseUp(0, 10, 20);
//
//        currentTool.onPointerClick(pointerEvent).verify(0);
//        Assert.areEqual(10, pointerEvent.screenX);
//        Assert.areEqual(20, pointerEvent.screenY);
//    }
//
//    @Test
//    public function shouldCaptureMouseMove(): Void {
//        gameTools.currentTool.returns(currentTool);
//
//        mouseInput.onMouseMove(0, 0, 32, 16);
//
//        currentTool.onPointerMove(pointerEvent).verify();
//        Assert.areEqual(32, pointerEvent.screenX);
//        Assert.areEqual(16, pointerEvent.screenY);
//    }
//
//    @Test
//    public function shouldCaptureMouseWheel(): Void {
//        gameTools.currentTool.returns(currentTool);
//
//        mouseInput.onMouseWheel(5);
//
//        currentTool.onScroll(pointerEvent).verify();
//        Assert.areEqual(5, pointerEvent.mouseWheelValue);
//    }
//
//    @Test
//    public function shouldCaptureRightMouseDown(): Void {
//        gameTools.currentTool.returns(currentTool);
//
//        mouseInput.onMouseDown(1, 10, 20);
//
//        currentTool.onPointerRightDown(pointerEvent).verify();
//        Assert.areEqual(10, pointerEvent.screenX);
//        Assert.areEqual(20, pointerEvent.screenY);
//    }
//
//    @Test
//    public function shouldCaptureRightMouseUp(): Void {
//        gameTools.currentTool.returns(currentTool);
//
//        mouseInput.onMouseDown(1, 10, 20);
//        mouseInput.onMouseUp(1, 10, 20);
//
//        currentTool.onPointerRightUp(pointerEvent).verify();
//        Assert.areEqual(10, pointerEvent.screenX);
//        Assert.areEqual(20, pointerEvent.screenY);
//    }
//
//    @Test
//    public function shouldNotCaptureRightClickIfRightMouseDownThenMoveMoreThan3PixelsThenRightMouseUp(): Void {
//        gameTools.currentTool.returns(currentTool);
//
//        mouseInput.onMouseDown(1, 10, 20);
//        mouseInput.onMouseMove(0, 0, 10, 16);
//        mouseInput.onMouseUp(1, 10, 20);
//
//        currentTool.onPointerRightClick(pointerEvent).verify(0);
//        Assert.areEqual(10, pointerEvent.screenX);
//        Assert.areEqual(20, pointerEvent.screenY);
//    }
//
//    @Test
//    public function shouldCaptureRightClickIfRightMouseDownThenMoveMoreThan3PixelsThenRightMouseUp(): Void {
//        gameTools.currentTool.returns(currentTool);
//
//        mouseInput.onMouseDown(1, 10, 20);
//        mouseInput.onMouseMove(0, 0, 10, 19);
//        mouseInput.onMouseUp(1, 10, 20);
//
//        currentTool.onPointerRightClick(pointerEvent).verify(1);
//        Assert.areEqual(10, pointerEvent.screenX);
//        Assert.areEqual(20, pointerEvent.screenY);
//    }
//
//    @Test
//    public function shouldDisposeAllReferences(): Void {
//        mouseInput.dispose();
//
//        objectCreator.disposeInstance(pointerEvent).verify();
//        Assert.isNull(mouseInput.objectCreator);
//        Assert.isNull(mouseInput.gameInputTools);
//        Assert.isNull(mouseInput.pointerEvent);
//    }
}