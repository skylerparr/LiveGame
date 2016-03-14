package animation.kha.two;

import display.two.kha.KhaBitmapNode;
import display.BitmapNode;
import animation.spec.TexturePackerJSONArrayFrameSpec;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class Kha2DAnimationTest {

    private var animation: TP_JSONArraySpriteAnimation;
    private var frames: TexturePackerJSONArrayFrameSpec;

    private var bitmap: KhaBitmapNode;

    public function new() {

    }

    @Before
    public function setup():Void {
        var frameData = {frames: [
            {
                frame: {x: 133, y: 1, w: 64, h: 61},
                rotated: false
            },
            {
                frame: {x: 199, y: 1, w: 63, h: 60},
                rotated: false
            },
            {
                frame: {x: 299, y: 100, w: 62, h: 62},
                rotated: false
            }
        ]};
        frames = new TexturePackerJSONArrayFrameSpec(frameData);
        bitmap = mock(KhaBitmapNode);
        animation = new TP_JSONArraySpriteAnimation();
        animation.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldShowFirstFrame(): Void {
        animation.bitmap = bitmap;
        animation.frames = frames.frames;

        bitmap.set_sx(133).verify();
        bitmap.set_sy(1).verify();
        bitmap.set_sw(64).verify();
        bitmap.set_sh(61).verify();
    }
}
