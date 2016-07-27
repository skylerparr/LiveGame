package animation;

import geom.Point;
import display.two.kha.KhaBitmapNode;
import display.BitmapNode;
import animation.spec.TexturePackerJSONArrayFrameSpec;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class SpriteAnimationTest {

    private var animation: SpriteAnimation;
    private var frames: TexturePackerJSONArrayFrameSpec;

    private var bitmap: KhaBitmapNode;

    @Before
    public function setup():Void {
        var frameData = {frames: [
            {
                frame: {x: 133, y: 1, w: 64, h: 61},
                rotated: false
            },
            {
                frame: {x: 199, y: 5, w: 63, h: 60},
                rotated: false
            },
            {
                frame: {x: 299, y: 100, w: 62, h: 62},
                rotated: false
            }
        ]};
        frames = new TexturePackerJSONArrayFrameSpec(frameData, new Point());
        bitmap = mock(KhaBitmapNode);
        animation = new SpriteAnimation();
        animation.init();

        animation.bitmap = bitmap;
        animation.frames = frames.frames;
    }

    @After
    public function tearDown():Void {
        frames = null;
        bitmap = null;
        animation = null;
    }

    @Test
    public function shouldShowFirstFrame(): Void {
        Assert.areEqual(0, animation.currentFrame);
        bitmap.set_sx(133).verify();
        bitmap.set_sy(1).verify();
        bitmap.set_sw(64).verify();
        bitmap.set_sh(61).verify();
    }

    @Test
    public function shouldShowNextFrame(): Void {
        animation.nextFrame();

        Assert.areEqual(1, animation.currentFrame);
        bitmap.set_sx(199).verify();
        bitmap.set_sy(5).verify();
        bitmap.set_sw(63).verify();
        bitmap.set_sh(60).verify();
    }

    @Test
    public function shouldShowPreviousFrame(): Void {
        animation.nextFrame();
        bitmap.reset();

        animation.prevFrame();

        Assert.areEqual(0, animation.currentFrame);
        bitmap.set_sx(133).verify();
        bitmap.set_sy(1).verify();
        bitmap.set_sw(64).verify();
        bitmap.set_sh(61).verify();
    }

    @Test
    public function shouldGoToSpecifiedFrame(): Void {
        bitmap.reset();

        animation.setFrame(2);

        Assert.areEqual(2, animation.currentFrame);
        bitmap.set_sx(299).verify();
        bitmap.set_sy(100).verify();
        bitmap.set_sw(62).verify();
        bitmap.set_sh(62).verify();
    }

    @Test
    public function shouldGoToFirstFrameIfAlreadyOnLastFrameWhenGoingToNextFrame(): Void {
        animation.setFrame(2);
        animation.nextFrame();
        Assert.areEqual(0, animation.currentFrame);
    }

    @Test
    public function shouldGoToLastFrameIfOnFirstFrame(): Void {
        animation.prevFrame();
        Assert.areEqual(2, animation.currentFrame);
    }

    @Test
    public function shouldGoToLastFrameWhenPassedGoToFrameWithMoreThanNumFrames(): Void {
        animation.setFrame(3);
        Assert.areEqual(2, animation.currentFrame);
    }

    @Test
    public function shouldDispseAllReferences(): Void {
        animation.dispose();

        Assert.isNull(animation.bitmap);
        Assert.isNull(animation.frames);
    }
}
