package display.layer;

import display.layer.RenderableLayerManager.RenderContainer;
import display.two.TwoDimDisplayNodeContainer;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class RenderableLayerManagerTest {

    private var layerManager: RenderableLayerManager;
    private var bottomContainer: DisplayNodeContainer;
    private var container: DisplayNodeContainer;
    private var renderer: Renderer;

    public function new() {

    }

    @Before
    public function setup():Void {
        container = new TwoDimDisplayNodeContainer();
        container.init();

        layerManager = new RenderableLayerManager(container);
        layerManager.init();

        bottomContainer = new TwoDimDisplayNodeContainer();
        bottomContainer.init();

        renderer = mock(Renderer);
    }

    @After
    public function tearDown():Void {
        layerManager = null;
        bottomContainer = null;
        renderer = null;
    }

    @Test
    public function shouldAddLayerByName(): Void {
        layerManager.addLayerByName("bottom", bottomContainer, renderer);
        var layers: Map<String, RenderContainer> = layerManager.getLayerMap();
        Assert.areEqual(bottomContainer, layers.get("bottom").container);
        Assert.areEqual(renderer, layers.get("bottom").renderer);
    }

    @Test
    public function shouldAddLayerToTopLevelContainer(): Void {
        layerManager.addLayerByName("bottom", bottomContainer, renderer);
        Assert.areEqual(container, bottomContainer.parent);
        Assert.areEqual(1, container.numChildren);
        Assert.areEqual(bottomContainer, container.getChildAt(0));
    }

    @Test
    public function shouldNotAddNullContainer(): Void {
        layerManager.addLayerByName("bottom", null, renderer);
        Assert.areEqual(0, container.numChildren);
    }

    @Test
    public function shouldNotAddANullRenderer(): Void {
        layerManager.addLayerByName("bottom", bottomContainer, null);
        Assert.areEqual(0, container.numChildren);
    }

    @Test
    public function shouldAddNewContainerToTheTopOfThePreviousContainer(): Void {
        var top: DisplayNodeContainer = new TwoDimDisplayNodeContainer();
        top.init();

        layerManager.addLayerByName("bottom", bottomContainer, renderer);
        layerManager.addLayerByName("top", top, renderer);

        Assert.areEqual(2, container.numChildren);
        Assert.areEqual(bottomContainer, container.getChildAt(0));
        Assert.areEqual(top, container.getChildAt(1));
    }

    @Test
    public function shouldGetLayerByName(): Void {
        var top: DisplayNodeContainer = new TwoDimDisplayNodeContainer();
        top.init();

        layerManager.addLayerByName("bottom", bottomContainer, renderer);
        layerManager.addLayerByName("top", top, renderer);

        Assert.areEqual(top, layerManager.getLayerByName("top"));
        Assert.areEqual(bottomContainer, layerManager.getLayerByName("bottom"));
    }

    @Test
    public function shouldReturnNullIfNotLayerFoundByName(): Void {
        layerManager.addLayerByName("bottom", bottomContainer, renderer);
        Assert.isNull(layerManager.getLayerByName("foo"));
    }

    @Test
    public function shouldReturnLayerNameIfPassedAContainer(): Void {
        layerManager.addLayerByName("bottom", bottomContainer, renderer);
        Assert.areEqual("bottom", layerManager.getLayerName(bottomContainer));
    }

    @Test
    public function shouldRemoveLayerByName(): Void {
        var top: DisplayNodeContainer = new TwoDimDisplayNodeContainer();
        top.init();

        layerManager.addLayerByName("bottom", bottomContainer, renderer);
        layerManager.addLayerByName("top", top, renderer);

        layerManager.removeLayerByName("bottom");

        Assert.areEqual(1, container.numChildren);
        Assert.isNull(bottomContainer.parent);
        Assert.areEqual(top, container.getChildAt(0));
    }

    @Test
    public function shouldNotRemoveLayerIfNameIsNotFound(): Void {
        var top: DisplayNodeContainer = new TwoDimDisplayNodeContainer();
        top.init();

        layerManager.addLayerByName("bottom", bottomContainer, renderer);
        layerManager.addLayerByName("top", top, renderer);

        layerManager.removeLayerByName("foo");

        Assert.areEqual(2, container.numChildren);
        Assert.areEqual(bottomContainer, container.getChildAt(0));
        Assert.areEqual(top, container.getChildAt(1));
    }
}