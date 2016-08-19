package input.kha;

import mocks.MockPointingTool;
import mocks.MockGameInputTools;
import core.ObjectCreator;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class KhaMouseInputSourceTest {

    private var mouseInput: KhaMouseInputSource;
    private var gameTools: MockGameInputTools;
    private var objectCreator: ObjectCreator;
    private var pointerEvent: PointerEvent;
    private var currentTool: MockPointingTool;

    @Before
    public function setup():Void {
        gameTools = mock(MockGameInputTools);
        objectCreator = mock(ObjectCreator);
        currentTool = mock(MockPointingTool);

        mouseInput = new KhaMouseInputSource();
        mouseInput.objectCreator = objectCreator;
        mouseInput.gameInputTools = gameTools;

        pointerEvent = new PointerEvent();
        objectCreator.createInstance(PointerEvent).returns(pointerEvent);

        mouseInput.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldCaptureLeftMouseDownAndPassToGameTool(): Void {
        gameTools.currentTool.returns(currentTool);

        mouseInput.onMouseDown(0, 10, 20);

        currentTool.onPointerDown(pointerEvent).verify();
        Assert.areEqual(10, pointerEvent.screenX);
        Assert.areEqual(20, pointerEvent.screenY);
    }

    @Test
    public function shouldCaptureRightMouseUpAndPassToGameTool(): Void {
        gameTools.currentTool.returns(currentTool);

        mouseInput.onMouseUp(0, 10, 20);

        currentTool.onPointerUp(pointerEvent).verify();
        Assert.areEqual(10, pointerEvent.screenX);
        Assert.areEqual(20, pointerEvent.screenY);
    }

    @Test
    public function shouldCaptureClickIfMouseDownThenMouseUp(): Void {
        gameTools.currentTool.returns(currentTool);

        mouseInput.onMouseDown(0, 10, 20);
        mouseInput.onMouseUp(0, 10, 20);

        currentTool.onPointerClick(pointerEvent).verify();
        Assert.areEqual(10, pointerEvent.screenX);
        Assert.areEqual(20, pointerEvent.screenY);
    }

    @Test
    public function shouldNotCaptureClickIfMouseDownThenMoveMoreThan3PixelsThenMouseUp(): Void {
        gameTools.currentTool.returns(currentTool);

        mouseInput.onMouseDown(0, 10, 20);
        mouseInput.onMouseMove(0, 0, 10, 16);
        mouseInput.onMouseUp(0, 10, 20);

        currentTool.onPointerClick(pointerEvent).verify(0);
        Assert.areEqual(10, pointerEvent.screenX);
        Assert.areEqual(20, pointerEvent.screenY);
    }

    @Test
    public function shouldCaptureMouseMove(): Void {
        gameTools.currentTool.returns(currentTool);

        mouseInput.onMouseMove(0, 0, 32, 16);

        currentTool.onPointerMove(pointerEvent).verify();
        Assert.areEqual(32, pointerEvent.screenX);
        Assert.areEqual(16, pointerEvent.screenY);
    }

    @Test
    public function shouldCaptureMouseWheel(): Void {
        gameTools.currentTool.returns(currentTool);

        mouseInput.onMouseWheel(5);

        currentTool.onScroll(pointerEvent).verify();
        Assert.areEqual(5, pointerEvent.mouseWheelValue);
    }

    @Test
    public function shouldCaptureRightMouseDown(): Void {
        gameTools.currentTool.returns(currentTool);

        mouseInput.onMouseDown(1, 10, 20);

        currentTool.onPointerRightDown(pointerEvent).verify();
        Assert.areEqual(10, pointerEvent.screenX);
        Assert.areEqual(20, pointerEvent.screenY);
    }

    @Test
    public function shouldCaptureRightMouseUp(): Void {
        gameTools.currentTool.returns(currentTool);

        mouseInput.onMouseDown(1, 10, 20);
        mouseInput.onMouseUp(1, 10, 20);

        currentTool.onPointerRightUp(pointerEvent).verify();
        Assert.areEqual(10, pointerEvent.screenX);
        Assert.areEqual(20, pointerEvent.screenY);
    }

    @Test
    public function shouldNotCaptureRightClickIfRightMouseDownThenMoveMoreThan3PixelsThenRightMouseUp(): Void {
        gameTools.currentTool.returns(currentTool);

        mouseInput.onMouseDown(1, 10, 20);
        mouseInput.onMouseMove(0, 0, 10, 16);
        mouseInput.onMouseUp(1, 10, 20);

        currentTool.onPointerRightClick(pointerEvent).verify(0);
        Assert.areEqual(10, pointerEvent.screenX);
        Assert.areEqual(20, pointerEvent.screenY);
    }

    @Test
    public function shouldCaptureRightClickIfRightMouseDownThenMoveMoreThan3PixelsThenRightMouseUp(): Void {
        gameTools.currentTool.returns(currentTool);

        mouseInput.onMouseDown(1, 10, 20);
        mouseInput.onMouseMove(0, 0, 10, 19);
        mouseInput.onMouseUp(1, 10, 20);

        currentTool.onPointerRightClick(pointerEvent).verify(1);
        Assert.areEqual(10, pointerEvent.screenX);
        Assert.areEqual(20, pointerEvent.screenY);
    }

    @Test
    public function shouldDisposeAllReferences(): Void {
        mouseInput.dispose();

        objectCreator.disposeInstance(pointerEvent).verify();
        Assert.isNull(mouseInput.objectCreator);
        Assert.isNull(mouseInput.gameInputTools);
        Assert.isNull(mouseInput.pointerEvent);
    }
}

