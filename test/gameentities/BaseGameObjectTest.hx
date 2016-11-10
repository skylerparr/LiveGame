package gameentities;

import world.two.WorldPoint2D;
import constants.Poses;
import world.two.Footprint2D;
import world.two.Bounds2D;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class BaseGameObjectTest {

    private var baseGameObject: BaseGameObject;

    @Before
    public function setup():Void {
        baseGameObject = new BaseGameObject();
        baseGameObject.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldAssignProperties(): Void {
        baseGameObject.bounds = new Bounds2D();
        baseGameObject.busy = true;
        baseGameObject.category = "foo";
        baseGameObject.footprint = new Footprint2D();
        baseGameObject.id = "fd";
        baseGameObject.pose = Poses.ATTACK;
        baseGameObject.type = "lkjfd";
        baseGameObject.x = 100;
        baseGameObject.y = 200;
        baseGameObject.z = 300;
        baseGameObject.lookAt = new WorldPoint2D(100, 200);
        baseGameObject.visible = false;

        Assert.areEqual(100, baseGameObject.worldPoint.x);
        Assert.areEqual(200, baseGameObject.worldPoint.y);
        Assert.areEqual(300, baseGameObject.worldPoint.z);

        Assert.areEqual(100, baseGameObject.lookAt.x);
        Assert.areEqual(200, baseGameObject.lookAt.z);

        Assert.areEqual(100, baseGameObject.x);
        Assert.areEqual(200, baseGameObject.y);
        Assert.areEqual(300, baseGameObject.z);
        Assert.isNotNull(baseGameObject.bounds);
        Assert.areEqual(true, baseGameObject.busy);
        Assert.areEqual("foo", baseGameObject.category);
        Assert.isNotNull(baseGameObject.footprint);
        Assert.areEqual("fd", baseGameObject.id);
        Assert.areEqual(Poses.ATTACK, baseGameObject.pose);
        Assert.areEqual("lkjfd", baseGameObject.type);

        Assert.areEqual(false, baseGameObject.visible);
    }

    @Test
    public function shouldDispose(): Void {
        baseGameObject.dispose();
        Assert.isNull(baseGameObject.worldPoint);
    }
}