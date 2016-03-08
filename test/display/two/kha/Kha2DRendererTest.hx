package display.two.kha;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class Kha2DRendererTest {

    private var khaRenderer: Kha2DRenderer;
    private var graphics: MockKha2DGraphics;
    private var container: KhaSprite;

    public function new() {

    }

    @Before
    public function setup():Void {
        container = new KhaSprite();
        container.init();
        khaRenderer = new Kha2DRenderer(container);
        khaRenderer.init();
        graphics = mock(MockKha2DGraphics);

        khaRenderer.graphics = graphics;
    }

    @After
    public function tearDown():Void {
        khaRenderer = null;
        graphics = null;
    }

    @Test
    public function shouldInjectGraphics(): Void {
        Assert.areEqual(graphics, khaRenderer.graphics);
    }
}