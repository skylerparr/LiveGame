package geom;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;


class RectangleTest {

    private var rectangle: Rectangle;

    @Before
    public function setup():Void {
        rectangle = new Rectangle(10, 20, 50, 60);
    }

    @After
    public function tearDown():Void {
        rectangle = null;
    }

    @Test
    public function shouldReturnTrueIfXAndYIsWithinRectangle(): Void {
        Assert.isTrue(rectangle.contains(50, 50));
    }

    @Test
    public function shouldReturnFalseIfXAndYIsNotWithinRectangle(): Void {
        Assert.isFalse(rectangle.contains(150, 250));
    }

    @Test
    public function shouldReturnTrueIfPointIsWithinRectangle(): Void {
        Assert.isTrue(rectangle.containsPoint(new Point(50, 50)));
    }

    @Test
    public function shouldReturnTrueIfPointIsOnTheEdgeOfTheRectangle(): Void {
        Assert.isTrue(rectangle.containsPoint(new Point(10, 20)));
        Assert.isTrue(rectangle.containsPoint(new Point(60, 80)));
    }

    @Test
    public function shouldReturnFalseIfPointDoesNotFallInsideRectangle(): Void {
        Assert.isFalse(rectangle.containsPoint(new Point(0, 0)));
    }

    @Test
    public function shouldReturnFalseIfPointIsNull(): Void {
        Assert.isFalse(rectangle.containsPoint(null));
    }

    @Test
    public function shouldReturnTrueIfTopLeftCornerOfRectangleIntersects(): Void {
        var rect2: Rectangle = new Rectangle(50, 50, 100, 100);
        Assert.isTrue(rectangle.intersects(rect2));
        Assert.isTrue(rect2.intersects(rectangle));
    }

    @Test
    public function shouldReturnTrueIfTopRightCornerOfRectangleIntersects(): Void {
        var rect2: Rectangle = new Rectangle(0, 50, 30, 100);
        Assert.isTrue(rectangle.intersects(rect2));
        Assert.isTrue(rect2.intersects(rectangle));
    }

    @Test
    public function shouldReturnTrueIfBottomLeftCornerOfRectangleIntersects(): Void {
        var rect2: Rectangle = new Rectangle(30, 0, 30, 50);
        Assert.isTrue(rectangle.intersects(rect2));
        Assert.isTrue(rect2.intersects(rectangle));
    }

    @Test
    public function shouldReturnTrueIfBottomRightCornerOfRectangleIntersects(): Void {
        var rect2: Rectangle = new Rectangle(0, 0, 60, 70);
        Assert.isTrue(rectangle.intersects(rect2));
        Assert.isTrue(rect2.intersects(rectangle));
    }

    @Test
    public function shouldReturnTrueIfTheEntireRectangleIsContainedInTheRectangle(): Void {
        var rect2: Rectangle = new Rectangle(15, 25, 10, 10);
        Assert.isTrue(rectangle.intersects(rect2));
        Assert.isTrue(rect2.intersects(rectangle));
    }

    @Test
    public function shouldReturnTrueIfTheEntireRectangleEngulfsTheRectangle(): Void {
        var rect2: Rectangle = new Rectangle(0, 0, 200, 200);
        Assert.isTrue(rectangle.intersects(rect2));
        Assert.isTrue(rect2.intersects(rectangle));
    }

    @Test
    public function shouldReturnFalseIfRectangleIsNull(): Void {
        Assert.isFalse(rectangle.intersects(null));
    }

    @Test
    public function shouldReturnFalseIfTheRectanglesDontIntersect(): Void {
        var rect2: Rectangle = new Rectangle(100, 100, 200, 200);
        Assert.isFalse(rectangle.intersects(rect2));
        Assert.isFalse(rect2.intersects(rectangle));
    }

    @Test
    public function shouldIntersect(): Void {
        var rect1: Rectangle = new Rectangle(390,110,20,20);
        var rect2: Rectangle = new Rectangle(0,0,400,300);
        Assert.isTrue(rect1.intersects(rect2));
        Assert.isTrue(rect2.intersects(rect1));
    }

    @Test
    public function shouldCloneItself(): Void {
        var rect2: Rectangle = rectangle.clone();
        Assert.areEqual(rectangle.x, rect2.x);
        Assert.areEqual(rectangle.y, rect2.y);
        Assert.areEqual(rectangle.width, rect2.width);
        Assert.areEqual(rectangle.height, rect2.height);
    }
}