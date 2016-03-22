package world.two;

import geom.Rectangle;
import display.DisplayNode;
import geom.Point;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class GameWorld2DTest {

    private var gameWorld: GameWorld2D;
    private var viewPort: MockViewPort;
    private var wp: WorldPoint2D;
    private var point: Point;

    public function new() {

    }

    @Before
    public function setup():Void {
        viewPort = mock(MockViewPort);
        wp = new WorldPoint2D();
        point = new Point();

        gameWorld = new GameWorld2D();
        gameWorld.viewPort = viewPort;
        gameWorld.init();
    }

    @After
    public function tearDown():Void {
        viewPort = null;
    }

    @Test
    public function shouldGetOriginWhenViewPortHasntTranslated(): Void {
        viewPort.x.returns(0);
        viewPort.y.returns(0);

        var p: Point = gameWorld.worldToScreen(wp);

        Assert.areEqual(0, p.x);
        Assert.areEqual(0, p.y);
    }

    @Test
    public function shouldGetViewPortTranslatedValueIfGetPointAtZeroZero(): Void {
        viewPort.x.returns(20);
        viewPort.y.returns(32);

        wp.x = 20;
        wp.y = 32;
        var p: Point = gameWorld.worldToScreen(wp);

        Assert.areEqual(0, p.x);
        Assert.areEqual(0, p.y);
    }

    @Test
    public function shouldGiveTranslatedPointWhenViewPortIsTranslated(): Void {
        viewPort.x.returns(20);
        viewPort.y.returns(32);

        wp.x = 14;
        wp.y = 18;
        var p: Point = gameWorld.worldToScreen(wp);

        Assert.areEqual(6, p.x);
        Assert.areEqual(14, p.y);
    }

    @Test
    public function shouldGiveZeroZeroIfViewPortIsNotTranslatedAndGetWorldPointOrigin(): Void {
        viewPort.x.returns(0);
        viewPort.y.returns(0);

        var wp: WorldPoint = gameWorld.screenToWorld(point);

        Assert.areEqual(0, wp.x);
        Assert.areEqual(0, wp.y);
    }

    @Test
    public function shouldGiveTranslatedValueIfViewPortHasMoved(): Void {
        viewPort.x.returns(10);
        viewPort.y.returns(20);

        var wp: WorldPoint = gameWorld.screenToWorld(point);

        Assert.areEqual(10, wp.x);
        Assert.areEqual(20, wp.y);
    }

    @Test
    public function shouldGiveTranslatedWorldPointIfViewPortMovedAndNotAtOrigin(): Void {
        viewPort.x.returns(10);
        viewPort.y.returns(20);

        point.x = 15;
        point.y = 26;
        var wp: WorldPoint = gameWorld.screenToWorld(point);

        Assert.areEqual(25, wp.x);
        Assert.areEqual(46, wp.y);
    }
}

class MockViewPort implements ViewPort {

    public function isInViewableRegion(value:DisplayNode):Bool {
        return false;
    }

    public function subscribeToTranslate(listener:Void->Void):Void {
    }

    public function unsubscribeToTranslate(listener:Void->Void):Void {
    }

    public function subscribeToResize(listener:Void->Void):Void {
    }

    public function unsubscribeToResize(listener:Void->Void):Void {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    @:isVar
    public var height(get, set):Float;

    @:isVar
    public var width(get, set):Float;

    @:isVar
    public var x(get, set):Float;

    @:isVar
    public var y(get, set):Float;

    @:isVar
    public var z(get, set):Float;

    @:isVar
    public var scale(get, set):Float;

    @:isVar
    public var dimension(get, set):Rectangle;

    public function new() {
    }

    public function set_height(value:Float) {
        return this.height = value;
    }

    public function get_height():Float {
        return height;
    }

    public function get_width():Float {
        return width;
    }

    public function set_width(value:Float) {
        return this.width = value;
    }

    public function get_x():Float {
        return x;
    }

    public function set_x(value:Float) {
        return this.x = value;
    }

    public function set_y(value:Float) {
        return this.y = value;
    }

    public function get_y():Float {
        return y;
    }

    public function set_z(value:Float) {
        return this.z = value;
    }

    public function get_z():Float {
        return z;
    }

    public function get_scale():Float {
        return scale;
    }

    public function set_scale(value:Float) {
        return this.scale = value;
    }

    public function get_dimension():Rectangle {
        return dimension;
    }

    public function set_dimension(value:Rectangle) {
        return this.dimension = value;
    }


}