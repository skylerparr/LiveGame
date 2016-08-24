package geom;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class PointTest {

    @Before
    public function setup():Void {
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldCalculateDistance(): Void {
        var p1: Point = new Point(10, 10);
        var p2: Point = new Point(20, 20);

        Assert.areEqual(14142, Math.floor(Point.distance(p1, p2) * 1000));
    }
}