package input.kha;

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
    private var currentTool: PointingTool;

    public function new() {

    }

    @Before
    public function setup():Void {
        gameTools = mock(MockGameInputTools);
        objectCreator = mock(ObjectCreator);
        currentTool = mock(PointingTool);

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
        Assert.areEqual(5, pointerEvent.mouseWheeValue);
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

class MockGameInputTools implements GameInputTools {

    public var currentTool(get, null):PointingTool;
    public var keyboardTool(get, null):KeyboardTool;

    public function get_currentTool():PointingTool {
        return currentTool;
    }

    public function get_keyboardTool():KeyboardTool {
        return keyboardTool;
    }

    public function new() {
    }
}

class MockPointingTool implements PointingTool {

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function onToolDeactivated(tool:PointingTool):Void {
    }

    public function onPointerDown(e:PointerEvent):Void {
    }

    public function onPointerMove(e:PointerEvent):Void {
    }

    public function onPointerUp(e:PointerEvent):Void {
    }

    public function onPointerClick(e:PointerEvent):Void {
    }

    public function onPointerRightClick(e:PointerEvent):Void {
    }

    public function onPointerRightDown(e:PointerEvent):Void {
    }

    public function onPointerRightUp(e:PointerEvent):Void {
    }

    public function onPointerDoubleClick(e:PointerEvent):Void {
    }

    public function onScroll(e:PointerEvent):Void {
    }

    public function onPointerMiddleDown(e:PointerEvent):Void {
    }

    public function onPointerMiddleUp(e:PointerEvent):Void {
    }

    public function onPointerMiddleClick(event:PointerEvent):Void {
    }

    public function activate(args:Array<Dynamic>):Void {
    }

    public function deactivate():Void {
    }

    public var name(get, null):String;

    public function get_name():String {
        return name;
    }

    public function new() {
    }
}