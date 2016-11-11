package gameentities.fx;

import constants.Poses;
import constants.LayerNames;
import mocks.MockAnimationWithEvents;
import animation.AnimationWithEvents;
import mocks.MockAnimation;
import world.two.WorldPoint2D;
import mocks.MockDisplayNodeContainer;
import assets.AssetLocator;
import core.ObjectCreator;
import display.LayerManager;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class UnitSpawnFXTest {

    private var unitSpawnFX: UnitSpawnFX;
    private var layerManager: LayerManager;
    private var objectCreator: ObjectCreator;
    private var assetLocator: AssetLocator;
    private var displayNode: MockDisplayNodeContainer;
    private var poseDisplay: AnimatedPoseDisplay;
    private var animation: MockAnimationWithEvents;

    @Before
    public function setup():Void {
        layerManager = mock(LayerManager);
        objectCreator = mock(ObjectCreator);
        assetLocator = mock(AssetLocator);
        displayNode = mock(MockDisplayNodeContainer);
        poseDisplay = mock(AnimatedPoseDisplay);
        animation = mock(MockAnimationWithEvents);
        poseDisplay.animation.returns(animation);
        layerManager.getLayerByName(LayerNames.FX).returns(displayNode);

        unitSpawnFX = new UnitSpawnFX();
        unitSpawnFX.layerManager = layerManager;
        unitSpawnFX.assetLocator = assetLocator;
        unitSpawnFX.objectCreator = objectCreator;
        unitSpawnFX.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldBeginSpawnEffect(): Void {
        objectCreator.createInstance(AnimatedPoseDisplay).returns(poseDisplay);

        unitSpawnFX.begin(new WorldPoint2D(100, 200));

        poseDisplay.generateAnimations(cast isNotNull).verify();
        poseDisplay.set_x(100).verify();
        poseDisplay.set_y(250).verify();
        animation.subscribeOnComplete(cast isNotNull).verify();
        displayNode.addChild(poseDisplay).verify();
    }

    @Test
    public function shouldSetPoseToRunAndUnsubscribeOnIdleComplete(): Void {
        objectCreator.createInstance(AnimatedPoseDisplay).returns(poseDisplay);
        animation.subscribeOnComplete(cast isNotNull).calls(function(args: Array<Dynamic>): Void {
            args[0](animation);
        });

        unitSpawnFX.begin(new WorldPoint2D(100, 200));

        animation.unsubscribeOnComplete(cast isNotNull).verify();
        poseDisplay.setPose(Poses.RUN);
    }

    @Test
    public function shouldEndAnimation(): Void {
        objectCreator.createInstance(AnimatedPoseDisplay).returns(poseDisplay);
        unitSpawnFX.begin(new WorldPoint2D(100, 200));

        var cbCalled: Bool = false;
        var f: AnimationWithEvents->Void = null;
        animation.subscribeOnComplete(cast isNotNull).calls(function(args: Array<Dynamic>): Void {
            f = args[0];
        });
        unitSpawnFX.end(function(fx: SpecialEffect): Void {
            cbCalled = true;
        });
        f(animation);

        Assert.isTrue(cbCalled);
        poseDisplay.setPose(Poses.DIE).verify();
        animation.unsubscribeOnComplete(cast isNotNull).verify();
    }

    @Test
    public function shouldCallCallbackImmediatelyIfDisplayIsNull(): Void {
        var cbCalled: Bool = false;
        unitSpawnFX.end(function(fx: SpecialEffect): Void {
            cbCalled = true;
        });
        Assert.isTrue(cbCalled);

        poseDisplay.setPose(Poses.DIE).verify(0);
        animation.unsubscribeOnComplete(cast isNotNull).verify(0);
    }

    @Test
    public function shouldNotCrashIfCallbackIsNull(): Void {
        objectCreator.createInstance(AnimatedPoseDisplay).returns(poseDisplay);
        unitSpawnFX.begin(new WorldPoint2D(100, 200));

        var cbCalled: Bool = false;
        var f: AnimationWithEvents->Void = null;
        animation.subscribeOnComplete(cast isNotNull).calls(function(args: Array<Dynamic>): Void {
            f = args[0];
        });
        unitSpawnFX.end(null);
        f(animation);

        Assert.isFalse(cbCalled);
    }

    @Test
    public function shouldDispose(): Void {
        objectCreator.createInstance(AnimatedPoseDisplay).returns(poseDisplay);
        var f: AnimationWithEvents->Void = null;
        animation.subscribeOnComplete(cast isNotNull).calls(function(args: Array<Dynamic>): Void {
            f = args[0];
        });
        unitSpawnFX.begin(new WorldPoint2D(100, 200));

        unitSpawnFX.dispose();

        displayNode.removeChild(poseDisplay).verify();
        animation.unsubscribeOnComplete(f).verify();
        objectCreator.disposeInstance(poseDisplay).verify();

        Assert.isNull(unitSpawnFX.container);
        Assert.isNull(unitSpawnFX.animatedPoseDisplay);
        Assert.isNull(unitSpawnFX.layerManager);
        Assert.isNull(unitSpawnFX.objectCreator);
        Assert.isNull(unitSpawnFX.assetLocator);
    }

    @Test
    public function shouldUnsubscribeEndFunctionOnDispose(): Void {
        objectCreator.createInstance(AnimatedPoseDisplay).returns(poseDisplay);
        unitSpawnFX.begin(new WorldPoint2D(100, 200));

        var cbCalled: Bool = false;
        var f: AnimationWithEvents->Void = null;
        animation.subscribeOnComplete(cast isNotNull).calls(function(args: Array<Dynamic>): Void {
            f = args[0];
        });
        unitSpawnFX.end(null);

        unitSpawnFX.dispose();
        animation.unsubscribeOnComplete(f).verify();
    }

    @Test
    public function shouldNotInvokeRemoveChildIfContainerIsNull(): Void {
        unitSpawnFX.container = null;
        unitSpawnFX.dispose();

        displayNode.removeChild(cast any).verify(0);
    }

    @Test
    public function shouldNotUnsubscribeIfPoseDisplayIsNull(): Void {
        unitSpawnFX.dispose();
        animation.unsubscribeOnComplete(cast any).verify(0);
    }

    @Test
    public function shouldNotDisposeInstanceIfObjectCreatorIsNull(): Void {
        unitSpawnFX.objectCreator = null;
        unitSpawnFX.dispose();

        objectCreator.disposeInstance(cast any).verify(0);
    }
}