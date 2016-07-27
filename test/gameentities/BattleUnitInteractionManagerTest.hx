package gameentities;

import world.WorldPoint;
import constants.Poses;
import mocks.MockTweenTarget;
import mocks.MockGameWorld;
import world.two.WorldPoint2D;
import world.GameWorld;
import core.ObjectCreator;
import animation.tween.TweenTarget;
import animation.tween.Tween;
import mocks.MockGameObject;
import massive.munit.Assert;

import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;
class BattleUnitInteractionManagerTest {

    private var interactionManager: BattleUnitInteractionManager;
    private var objectCreator: ObjectCreator;
    private var gameWorld: GameWorld;
    private var wp: WorldPoint2D;
    private var tween:Tween;
    private var tweenTarget:MockTweenTarget;
    private var gameObject: MockGameObject;
    private var updateFunction: Tween->Void;
    private var completeFunction: Tween->Void;

    @Before
    public function setup():Void {
        objectCreator = mock(ObjectCreator);
        gameWorld = mock(MockGameWorld);
        wp = new WorldPoint2D();
        tween = mock(Tween);
        tweenTarget = mock(MockTweenTarget);
        tweenTarget.onUpdate(cast any).returns(tweenTarget);
        tweenTarget.onComplete(cast any).returns(tweenTarget);
        tweenTarget.onBegin(cast any).returns(tweenTarget);

        gameObject = mock(MockGameObject);
        objectCreator.createInstance(Tween).returns(tween);

        objectCreator.createInstance(WorldPoint2D).calls(function(args): WorldPoint2D {
            return new WorldPoint2D();
        });

        interactionManager = new BattleUnitInteractionManager();
        interactionManager.gameWorld = gameWorld;
        interactionManager.objectCreator = objectCreator;
        interactionManager.init();
    }

    @After
    public function tearDown():Void {
        updateFunction = null;
        completeFunction = null;
    }

    @Test
    public function shouldTranslateGameObjectToNewLocation():Void {
        tween.to(cast any, 100, cast any).returns(tweenTarget);

        gameObject.get_x().returns(321);
        gameObject.get_z().returns(23);

        wp.x = 23;
        wp.z = 47;
        interactionManager.translateGameObjectTo(gameObject, wp, 100);

        tween.to(cast any, 100, cast any).verify();
    }

    @Test
    public function shouldStartTheTweenAtUnitCurrentLocationAndTargetPassedInWorldPoint(): Void {
        tween.to(cast any, 100, cast any).calls(function(args) {
            Assert.areEqual(321, args[0].x);
            Assert.areEqual(23, args[0].z);

            Assert.areEqual(23, args[2].x);
            Assert.areEqual(47, args[2].z);
            return tweenTarget;
        });

        gameObject.get_x().returns(321);
        gameObject.get_z().returns(23);

        wp.x = 23;
        wp.z = 47;
        interactionManager.translateGameObjectTo(gameObject, wp, 100);

        tween.to(cast any, 100, cast any).verify();
    }

    @Test
    public function shouldUpdateTheGameWorldOnTweenUpdate(): Void {
        tweenTarget.reset();
        tween.to(cast any, 100, cast any).returns(tweenTarget);

        tweenTarget.onUpdate(cast any).calls(assignUpdateFunction);

        gameObject.get_x().returns(321);
        gameObject.get_z().returns(23);

        wp.x = 23;
        wp.z = 47;
        interactionManager.translateGameObjectTo(gameObject, wp, 100);

        callOnUpdate();
        gameWorld.moveItemTo(gameObject, cast any).verify();
    }

    @Test
    public function shouldSetTheUnitPoseToRunOnUpdate(): Void {
        tweenTarget.reset();
        tween.to(cast any, 100, cast any).returns(tweenTarget);

        tweenTarget.onUpdate(cast any).calls(assignUpdateFunction);

        gameObject.get_x().returns(321);
        gameObject.get_z().returns(23);

        wp.x = 23;
        wp.z = 47;
        interactionManager.translateGameObjectTo(gameObject, wp, 100);

        callOnUpdate();
        gameObject.set_pose(Poses.RUN).verify();
    }

    @Test
    public function shouldSetUnitPoseToIdleOnComplete(): Void {
        tweenTarget.reset();
        tween.to(cast any, 100, cast any).returns(tweenTarget);

        tweenTarget.onUpdate(cast any).returns(tweenTarget);
        tweenTarget.onComplete(cast any).calls(assignCompleteFunction);

        gameObject.get_x().returns(321);
        gameObject.get_z().returns(23);

        wp.x = 23;
        wp.z = 47;
        interactionManager.translateGameObjectTo(gameObject, wp, 100);

        callOnComplete();
        gameObject.set_pose(Poses.IDLE).verify();
    }

    @Test
    public function shouldStopPreviousTweenIfAppliedToSameGameObject(): Void {
        tween.to(cast any, 100, cast any).returns(tweenTarget);

        gameObject.get_x().returns(321);
        gameObject.get_z().returns(23);

        wp.x = 23;
        wp.z = 47;
        interactionManager.translateGameObjectTo(gameObject, wp, 100);
        interactionManager.translateGameObjectTo(mock(MockGameObject), wp, 100);

        wp.x = 123;
        wp.z = 147;
        interactionManager.translateGameObjectTo(gameObject, wp, 100);

        objectCreator.disposeInstance(tween).verify();
        tween.to(cast any, 100, cast any).verify(3);
    }

    @Test
    public function shouldDisposeTweenWhenComplete(): Void {
        tweenTarget.reset();
        tween.to(cast any, 100, cast any).returns(tweenTarget);

        tweenTarget.onUpdate(cast any).returns(tweenTarget);
        tweenTarget.onComplete(cast any).calls(assignCompleteFunction);

        gameObject.get_x().returns(321);
        gameObject.get_z().returns(23);

        wp.x = 23;
        wp.z = 47;
        interactionManager.translateGameObjectTo(gameObject, wp, 100);

        callOnComplete();
        objectCreator.disposeInstance(tween).verify();
        Assert.isNull(interactionManager.objectTweenMap.get(gameObject));
    }

    @Test
    public function shouldDisposeAllObject(): Void {
        interactionManager.dispose();
        Assert.isNull(interactionManager.gameWorld);
        Assert.isNull(interactionManager.objectCreator);
        Assert.isNull(interactionManager.objectTweenMap);
    }

    @IgnoreCover
    private function assignUpdateFunction(args):TweenTarget {
        updateFunction = args[0];
        return tweenTarget;
    }

    @IgnoreCover
    private function assignCompleteFunction(args):TweenTarget {
        completeFunction = args[0];
        return tweenTarget;
    }

    @IgnoreCover
    private function callOnComplete():Void {
        if(completeFunction != null) {
            completeFunction(tween);
        }
    }

    @IgnoreCover
    private function callOnUpdate():Void {
        if(updateFunction != null) {
            updateFunction(tween);
        }
    }

}