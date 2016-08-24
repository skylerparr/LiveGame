package display.two.kha;

import mocks.MockMouseNotifier;
import input.DisplayEventMouseInputHandler;
import mocks.TestableGraphics;
import mocks.MockKhaFont;
import massive.munit.Assert;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class Kha2DRendererTest {

    private var khaRenderer: Kha2DRenderer;
    private var graphics: TestableGraphics;
    private var container: KhaSprite;
    private var fonts: Map<String, MockKhaFont>;
    private var displayEventMouseInputHandler: DisplayEventMouseInputHandler;

    @Before
    public function setup():Void {
        displayEventMouseInputHandler = mock(DisplayEventMouseInputHandler);
        container = new KhaSprite();
        container.init();
        khaRenderer = new Kha2DRenderer();
        khaRenderer.inputHandler = displayEventMouseInputHandler;
        khaRenderer.init();
        khaRenderer.container = container;
        graphics = mock(TestableGraphics);
        fonts = new Map<String, MockKhaFont>();
        fonts.set("sample", mock(MockKhaFont));

        khaRenderer.graphics = graphics;
        Kha2DRenderer.fonts = fonts;
    }

    @After
    public function tearDown():Void {
        khaRenderer = null;
        graphics = null;
    }

    @Test
    public function shouldDrawABitmap(): Void {
        var bitmap: KhaBitmapNode = mock(KhaBitmapNode);
        var imageData: Dynamic = {};
        bitmap.imageData.returns(imageData);
        bitmap.x.returns(10);
        bitmap.y.returns(20);
        bitmap.sx.returns(30);
        bitmap.sy.returns(40);
        bitmap.sw.returns(50);
        bitmap.sh.returns(60);
        container.addChild(bitmap);

        khaRenderer.render();
        bitmap.imageData.verify(2);
        bitmap.x.verify();
        bitmap.y.verify();
        bitmap.sx.verify();
        bitmap.sy.verify();
        bitmap.sw.verify();
        bitmap.sh.verify();

        graphics.drawSubImage(imageData, 10, 20, 30, 40, 50, 60).verify();
    }

    @Test
    public function shouldNotThrowExceptionIfBitmapImageDataIsNull(): Void {
        var bitmap: KhaBitmapNode = mock(KhaBitmapNode);
        bitmap.imageData.returns(null);
        bitmap.x.returns(10);
        bitmap.y.returns(20);
        bitmap.sx.returns(30);
        bitmap.sy.returns(40);
        bitmap.sw.returns(50);
        bitmap.sh.returns(60);
        container.addChild(bitmap);

        khaRenderer.render();
        bitmap.imageData.verify(1);
        bitmap.x.verify(0);
        bitmap.y.verify(0);
        bitmap.sx.verify(0);
        bitmap.sy.verify(0);
        bitmap.sw.verify(0);
        bitmap.sh.verify(0);

        graphics.drawSubImage(null, 10, 20, 30, 40, 50, 60).verify(0);
    }

    @Test
    public function shouldDrawATextField(): Void {
        var textField: KhaTextFieldNode = createTextField();
        textField.fontSize.returns(10);
        textField.fontName.returns("sample");
        textField.fontColor.returns(200);
        textField.text.returns("foo");
        textField.x.returns(1);
        textField.y.returns(2);

        container.addChild(textField);

        khaRenderer.render();
        textField.fontColor.verify();
        textField.fontSize.verify();
        textField.fontName.verify();
        textField.text.verify();
        textField.x.verify();
        textField.y.verify();

        graphics.set_fontSize(10).verify();
        graphics.set_font(fonts.get("sample")).verify();
        graphics.set_color(cast any).verify(2);
        graphics.drawString("foo", 1, 2).verify();
    }

    @Test
    public function shouldHoldContainerOfKhaSprite(): Void {
        var bitmap: KhaBitmapNode = mock(KhaBitmapNode);
        var imageData: Dynamic = {};
        bitmap.imageData.returns(imageData);
        var textField: KhaTextFieldNode = createTextField();
        var child: KhaSprite = mock(KhaSprite);
        child.children.returns([textField, bitmap]);

        container.addChild(child);
        khaRenderer.render();

        child.children.verify();
        child.x.verify();
        child.y.verify();
        bitmap.x.verify();
        bitmap.y.verify();
        textField.x.verify();
        textField.y.verify();
    }

    @Test
    public function shouldOffsetChildrenFromParent(): Void {
        var bitmap: KhaBitmapNode = mock(KhaBitmapNode);
        var imageData: Dynamic = {};
        bitmap.imageData.returns(imageData);
        bitmap.x.returns(1);
        bitmap.y.returns(2);

        var textField: KhaTextFieldNode = createTextField();
        textField.x.returns(3);
        textField.y.returns(4);
        var child: KhaSprite = mock(KhaSprite);
        child.x.returns(100);
        child.y.returns(50);
        child.children.returns([textField, bitmap]);

        container.addChild(child);
        khaRenderer.render();

        graphics.drawSubImage(cast any, 101, 52, 0, 0, 0, 0).verify();
        graphics.drawString(null, 103, 54).verify();
    }

    @Test
    public function shouldOffsetChildWithStartingTopContainer(): Void {
        container.x = 25;
        container.y = 35;

        var bitmap: KhaBitmapNode = mock(KhaBitmapNode);
        var imageData: Dynamic = {};
        bitmap.imageData.returns(imageData);
        bitmap.x.returns(1);
        bitmap.y.returns(2);

        var textField: KhaTextFieldNode = createTextField();
        textField.x.returns(3);
        textField.y.returns(4);
        var child: KhaSprite = mock(KhaSprite);
        child.x.returns(100);
        child.y.returns(50);
        child.children.returns([textField, bitmap]);

        container.addChild(child);
        khaRenderer.render();

        graphics.drawSubImage(cast any, 126, 87, 0, 0, 0, 0).verify();
        graphics.drawString(null, 128, 89).verify();
    }

    @Test
    public function shouldPassMouseDownEventToDisplayEventMouseInputHandler(): Void {
        var handler: MockMouseNotifier = khaRenderer.getMouseHandlers();
        handler.onMouseDown(0, 4, 21);

        displayEventMouseInputHandler.mouseDown(cast isNotNull, 0, 4, 21).verify();
    }

    @Test
    public function shouldPassMouseUpEventToDisplayEventMouseInputHandler(): Void {
        var handler: MockMouseNotifier = khaRenderer.getMouseHandlers();
        handler.onMouseUp(0, 54, 321);

        displayEventMouseInputHandler.mouseUp(cast isNotNull, 0, 54, 321).verify();
    }

    @Test
    public function shouldPassMouseWheelEventToDisplayEventMouseInputHandler(): Void {
        var handler: MockMouseNotifier = khaRenderer.getMouseHandlers();
        handler.onMouseWheel(21);

        displayEventMouseInputHandler.mouseWheel(cast isNotNull, 21).verify();
    }

    @Test
    public function shouldPassMouseMoveOnRender(): Void {
        var handler: MockMouseNotifier = khaRenderer.getMouseHandlers();
        handler.onMouseMove(5, 6, 0, 0);

        displayEventMouseInputHandler.mouseMove(cast isNotNull, 5, 6).verify(0);

        khaRenderer.render();

        displayEventMouseInputHandler.mouseMove(cast isNotNull, 5, 6).verify();
    }

    @Test
    public function shouldCollectItemsUnderMousePoint(): Void {
        var bitmap: KhaBitmapNode = mock(KhaBitmapNode);
        var imageData: Dynamic = {};
        bitmap.imageData.returns(imageData);
        bitmap.x.returns(1);
        bitmap.y.returns(2);
        bitmap.width.returns(10);
        bitmap.height.returns(20);

        var handler: MockMouseNotifier = khaRenderer.getMouseHandlers();
        handler.onMouseMove(5, 6, 0, 0);

        var child: KhaSprite = mock(KhaSprite);
        child.x.returns(0);
        child.y.returns(0);
        child.width.returns(100);
        child.height.returns(200);
        child.children.returns([bitmap]);

        container.addChild(child);

        displayEventMouseInputHandler.mouseMove(cast isNotNull, 5, 6).calls(function(args): Void {
            var objects: List<DisplayNode> = args[0];
            Assert.areEqual(2, objects.length);
            Assert.areEqual(child, objects.pop());
            Assert.areEqual(bitmap, objects.pop());
        });

        khaRenderer.render();

        displayEventMouseInputHandler.mouseMove(cast isNotNull, 5, 6).verify();
    }

    @Test
    public function shouldNotNotifyUnlessMouseHasMoved(): Void {
        var handler: MockMouseNotifier = khaRenderer.getMouseHandlers();
        handler.onMouseMove(5, 6, 0, 0);

        displayEventMouseInputHandler.mouseMove(cast isNotNull, 5, 6).verify(0);

        khaRenderer.render();
        khaRenderer.render();
        khaRenderer.render();
        khaRenderer.render();

        displayEventMouseInputHandler.mouseMove(cast isNotNull, 5, 6).verify();

        handler.onMouseMove(6, 7, 0, 0);
        khaRenderer.render();

        displayEventMouseInputHandler.mouseMove(cast isNotNull, 6, 7).verify();
    }

    @Test
    public function shouldDisposeAllReferences(): Void {
        khaRenderer.dispose();

        Assert.isNull(khaRenderer.graphics);
        Assert.isNull(khaRenderer.container);
    }

    @IgnoreCover
    private inline function createTextField(): KhaTextFieldNode {
        var textField: KhaTextFieldNode = mock(KhaTextFieldNode);
        textField.fontName.returns("sample");
        return textField;
    }
}



