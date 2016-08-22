package input;

import mocks.MockBitmapNode;
import display.BitmapNode;
import display.DisplayNodeContainer;
import mocks.MockDisplayNodeContainer;
import display.DisplayNode;
import core.ObjectCreator;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class DisplayEventMouseInputHandlerDelegateTest {

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

    @Test
    public function shouldFindFirstDisplayContainerWithMouseEnabledButMouseChildrenDisabled(): Void {
        var child0: DisplayNodeContainer = createDisplay(true, true);
        nodes.push(child0);
        var child1: DisplayNodeContainer = createDisplay(true, true);
        nodes.push(child1);
        var child2: DisplayNodeContainer = createDisplay(true, false);
        nodes.push(child2);
        var child3: DisplayNodeContainer = createDisplay(true, true);
        nodes.push(child3);

        sourceListener.onPointerDown(cast isNotNull).calls(function(args): Void {
            var pointerEvent: PointerEvent = args[0];
            Assert.areEqual(child2, pointerEvent.target);
        });

        delegate.mouseDown(nodes, 0, 10, 20);

        sourceListener.onPointerDown(cast isNotNull).verify();
    }

    @Test
    public function shouldFindFirstDisplayThatIsMouseEnableAndNotContainer(): Void {
        var child0: DisplayNodeContainer = createDisplay(true, true);
        nodes.push(child0);
        var child1: DisplayNodeContainer = createDisplay(true, true);
        nodes.push(child1);
        var child2: MockBitmapNode = mock(MockBitmapNode);
        child2.get_mouseEnabled().returns(true);
        nodes.push(child2);

        sourceListener.onPointerDown(cast isNotNull).calls(function(args): Void {
            var pointerEvent: PointerEvent = args[0];
            Assert.areEqual(child2, pointerEvent.target);
        });

        delegate.mouseDown(nodes, 0, 10, 20);

        sourceListener.onPointerDown(cast isNotNull).verify();
    }

    @Test
    public function shouldNotFirePointerDownIfNoDisplayFound(): Void {
        var child0: DisplayNodeContainer = createDisplay(true, true);
        nodes.push(child0);
        var child1: DisplayNodeContainer = createDisplay(true, true);
        nodes.push(child1);
        var child2: MockBitmapNode = mock(MockBitmapNode);
        nodes.push(child2);

        delegate.mouseDown(nodes, 0, 10, 20);

        sourceListener.onPointerDown(cast isNotNull).verify(0);
    }

    @Test
    public function shouldFireMouseMove(): Void {
        setupDisplay();

        delegate.mouseMove(nodes, 10, 20);

        sourceListener.onPointerMove(cast isNotNull).verify();
    }

    @Test
    public function shouldFireMouseUp(): Void {
        setupDisplay();
        delegate.mouseUp(nodes, 0, 10, 20);

        sourceListener.onPointerUp(cast isNotNull).verify();
    }

    @Test
    public function shouldFireRightMouseDown(): Void {
        setupDisplay();
        delegate.mouseDown(nodes, 1, 10, 20);

        sourceListener.onPointerRightDown(cast isNotNull).verify();
    }

    @Test
    public function shouldFireRightMouseUp(): Void {
        setupDisplay();
        delegate.mouseUp(nodes, 1, 10, 20);

        sourceListener.onPointerRightUp(cast isNotNull).verify();
    }

    @Test
    public function shouldFireClickWhenMouseDownAndMouseUpOverSameTarget(): Void {
        setupDisplay();
        delegate.mouseDown(nodes, 0, 10, 20);
        delegate.mouseUp(nodes, 0, 10, 20);

        sourceListener.onPointerClick(cast isNotNull).verify();
    }

    @Test
    public function shouldNotFireClickWhenTargetIsNull(): Void {
        var child0: DisplayNodeContainer = createDisplay(true, true);
        nodes.push(child0);
        var child1: DisplayNodeContainer = createDisplay(true, true);
        nodes.push(child1);
        var child2: MockBitmapNode = mock(MockBitmapNode);
        nodes.push(child2);
        delegate.mouseDown(nodes, 0, 10, 20);
        delegate.mouseUp(nodes, 0, 10, 20);

        sourceListener.onPointerClick(cast isNotNull).verify(0);
    }

    @Test
    public function shouldFireRightClickWhenMouseDownAndMouseUpOverSameTarget(): Void {
        setupDisplay();
        delegate.mouseDown(nodes, 1, 10, 20);
        delegate.mouseUp(nodes, 1, 10, 20);

        sourceListener.onPointerRightClick(cast isNotNull).verify();
    }

    @Test
    public function shouldFireWheelEvent(): Void {
        setupDisplay();
        delegate.mouseWheel(nodes, 2);
        sourceListener.onScroll(cast isNotNull).verify();
    }

    @Test
    public function shouldDispose(): Void {
        var pointerEvent: PointerEvent = delegate.pointerEvent;
        delegate.dispose();
        objectCreator.disposeInstance(pointerEvent).verify();
        Assert.isNull(delegate.objectCreator);
        Assert.isNull(delegate.currentTarget);
        Assert.isNull(delegate.pointerEvent);
        Assert.isNull(delegate.pointingInputSourceListener);
    }

    private inline function setupDisplay(): Void {
        var child0: DisplayNodeContainer = createDisplay(true, true);
        nodes.push(child0);
        var child1: DisplayNodeContainer = createDisplay(true, true);
        nodes.push(child1);
        var child2: MockBitmapNode = mock(MockBitmapNode);
        child2.get_mouseEnabled().returns(true);
        nodes.push(child2);
    }

    private inline function createDisplay(mouseEnabled: Bool, mouseChildren: Bool): DisplayNodeContainer {
        var retVal: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        retVal.get_mouseEnabled().returns(mouseEnabled);
        retVal.get_mouseChildren().returns(mouseChildren);
        return retVal;
    }

}