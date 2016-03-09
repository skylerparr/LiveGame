package display.layer;

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

    }

    @After
    public function tearDown():Void {
        layerManager = null;
        bottomContainer = null;
    }

    @Test
    public function shouldAddLayerByName(): Void {
        layerManager.addLayerByName("bottom", bottomContainer);
        var layers: Map<String, DisplayNodeContainer> = layerManager.getLayerMap();
        Assert.areEqual(bottomContainer, layers.get("bottom"));
    }

    @Test
    public function shouldAddLayerToTopLevelContainer(): Void {
        layerManager.addLayerByName("bottom", bottomContainer);
        Assert.areEqual(container, bottomContainer.parent);
        Assert.areEqual(1, container.numChildren);
        Assert.areEqual(bottomContainer, container.getChildAt(0));
    }

    @Test
    public function shouldNotAddNullContainer(): Void {
        layerManager.addLayerByName("bottom", null);
        Assert.areEqual(0, container.numChildren);
    }

    @Test
    public function shouldAddNewContainerToTheTopOfThePreviousContainer(): Void {
        var top: DisplayNodeContainer = new TwoDimDisplayNodeContainer();
        top.init();

        layerManager.addLayerByName("bottom", bottomContainer);
        layerManager.addLayerByName("top", top);

        Assert.areEqual(2, container.numChildren);
        Assert.areEqual(bottomContainer, container.getChildAt(0));
        Assert.areEqual(top, container.getChildAt(1));
    }

    @Test
    public function shouldGetLayerByName(): Void {
        var top: DisplayNodeContainer = new TwoDimDisplayNodeContainer();
        top.init();

        layerManager.addLayerByName("bottom", bottomContainer);
        layerManager.addLayerByName("top", top);

        Assert.areEqual(top, layerManager.getLayerByName("top"));
        Assert.areEqual(bottomContainer, layerManager.getLayerByName("bottom"));
    }

    @Test
    public function shouldReturnNullIfNotLayerFoundByName(): Void {
        layerManager.addLayerByName("bottom", bottomContainer);
        Assert.isNull(layerManager.getLayerByName("foo"));
    }

    @Test
    public function shouldReturnLayerNameIfPassedAContainer(): Void {
        layerManager.addLayerByName("bottom", bottomContainer);
        Assert.areEqual("bottom", layerManager.getLayerName(bottomContainer));
    }

    @Test
    public function shouldRemoveLayerByName(): Void {
        var top: DisplayNodeContainer = new TwoDimDisplayNodeContainer();
        top.init();

        layerManager.addLayerByName("bottom", bottomContainer);
        layerManager.addLayerByName("top", top);

        layerManager.removeLayerByName("bottom");

        Assert.areEqual(1, container.numChildren);
        Assert.isNull(bottomContainer.parent);
        Assert.areEqual(top, container.getChildAt(0));
    }

    @Test
    public function shouldNotRemoveLayerIfNameIsNotFound(): Void {
        var top: DisplayNodeContainer = new TwoDimDisplayNodeContainer();
        top.init();

        layerManager.addLayerByName("bottom", bottomContainer);
        layerManager.addLayerByName("top", top);

        layerManager.removeLayerByName("foo");

        Assert.areEqual(2, container.numChildren);
        Assert.areEqual(bottomContainer, container.getChildAt(0));
        Assert.areEqual(top, container.getChildAt(1));
    }
}