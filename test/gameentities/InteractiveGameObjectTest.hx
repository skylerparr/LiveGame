package gameentities;

import world.two.WorldPoint2D;
import constants.Poses;
import mocks.MockDisplayNodeContainer;
import world.GameObject;
import display.DisplayNode;
import animation.Animation;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class InteractiveGameObjectTest {

    private var gameObject: InteractiveGameObject;
    private var animation: Animation;
    private var displayNode: AnimatedPoseDisplay;

    @Before
    public function setup():Void {
        gameObject = new InteractiveGameObject();
        gameObject.init();

        animation = mock(Animation);
        displayNode = mock(AnimatedPoseDisplay);

        gameObject.animation = animation;
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldSetTheDisplayNode(): Void {
        displayNode.get_width().returns(100);
        displayNode.get_height().returns(200);

        gameObject.display = displayNode;

        Assert.areEqual(displayNode, gameObject.display);
    }

    @Test
    public function shouldSetPose(): Void {
        gameObject.display = displayNode;
        gameObject.set_pose(Poses.ATTACK);
        Assert.areEqual(Poses.ATTACK, gameObject.pose);
        displayNode.setPose(Poses.ATTACK).verify();
    }

    @Test
    public function shouldSetLookAt(): Void {
        gameObject.display = displayNode;
        var wp = gameObject.set_lookAt(new WorldPoint2D());
        displayNode.setDirection(0);
        Assert.areEqual(0, wp.x);
        Assert.areEqual(0, wp.y);
        Assert.areEqual(0, wp.z);
    }

    @Test
    public function shouldDispose(): Void {
        gameObject.display = displayNode;

        gameObject.dispose();
        Assert.isNull(gameObject.display);
        Assert.isNull(gameObject.animation);
    }

    @Test
    public function shouldNotSetDirectionIfDisplayIsNull(): Void {
        gameObject.set_lookAt(new WorldPoint2D());
        displayNode.setDirection(0).verify(0);
    }

    @Test
    public function shouldNotSetPoseIfDisplayIsNull(): Void {
        gameObject.set_pose(Poses.IDLE);
        displayNode.setPose(Poses.IDLE).verify(0);
    }
}