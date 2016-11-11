package gameentities;

import gameentities.AnimatedPoseDisplay;
import core.ObjectCreator;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class StaticUnitFactoryTest {

    private var unitFactory: StaticUnitFactory;
    private var objectCreator: ObjectCreator;
    private var animatedPoseDisplay: AnimatedPoseDisplay;

    @Before
    public function setup():Void {
        objectCreator = mock(ObjectCreator);

        unitFactory = new StaticUnitFactory();
        unitFactory.objectCreator = objectCreator;
        unitFactory.init();

        animatedPoseDisplay = mock(AnimatedPoseDisplay);
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldCreateAnimatedDisplay(): Void {
        objectCreator.createInstance(AnimatedPoseDisplay).returns(animatedPoseDisplay);
        var display: AnimatedPoseDisplay = unitFactory.createUnitDisplayByUnitTypeId("1");
        Assert.isNotNull(display);
        animatedPoseDisplay.generateAnimations(cast isNotNull).verify();
    }

    @Test
    public function shouldDispose(): Void {
        unitFactory.dispose();
        Assert.isNull(unitFactory.objectCreator);
        Assert.isNull(unitFactory.mapping);
    }
}