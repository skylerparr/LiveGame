package gameentities;

import animation.spec.TexturePackerJSONArrayFrameSpec;
import mocks.MockBitmapNode;
import display.BitmapNode;
import animation.AnimationWithEvents;
import mocks.MockAnimationWithEvents;
import mocks.MockAnimationController;
import animation.AnimationController;
import constants.Poses;
import mocks.MockImageAsset;
import assets.ImageAsset;
import assets.AssetLocator;
import core.ObjectCreator;
import massive.munit.Assert;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class AnimatedPoseDisplayTest {

    private var animatedPoseDisplay: AnimatedPoseDisplay;
    private var objectCreator: ObjectCreator;
    private var assetLocator: AssetLocator;
    private var animationController: MockAnimationController;
    private var animation: MockAnimationWithEvents;
    private var bitmapNode: MockBitmapNode;

    @Before
    public function setup():Void {
        objectCreator = mock(ObjectCreator);
        assetLocator = mock(AssetLocator);
        animationController = mock(MockAnimationController);
        animation = mock(MockAnimationWithEvents);
        bitmapNode = mock(MockBitmapNode);

        objectCreator.createInstance(cast isNotNull).calls(mockCreateInstance);
        objectCreator.createInstance(cast isNotNull, cast isNotNull).calls(mockCreateInstanceWithArgs);

        var imageAsset: MockImageAsset = mock(MockImageAsset);
        assetLocator.getAssetByName("foo", cast isNotNull).calls(function(args): Void {
            args[1](imageAsset);
        });
        assetLocator.getDataAssetByName("_00_foo_json", cast isNotNull).calls(function(args): Void {
            var frameString: String = '{"frames":[{"frame":{"h":161,"w":185,"x":0,"y":0}}]}';
            args[1](frameString);
        });

        animatedPoseDisplay = new AnimatedPoseDisplay();
        animatedPoseDisplay.objectCreator = objectCreator;
        animatedPoseDisplay.assetLocator = assetLocator;
        animatedPoseDisplay.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldGenerateAnimations(): Void {
        animatedPoseDisplay.generateAnimations([
            {pose: Poses.IDLE, assetName: "foo", numberOfDirections: 1}
        ]);

        animationController.set_animation(animation).verify();
        animationController.start().verify();
        bitmapNode.set_x(185 * -0.5).verify();
        bitmapNode.set_y(-161).verify();

        Assert.areEqual(bitmapNode, animatedPoseDisplay.getChildAt(0));
    }

    @IgnoreCover
    private function mockCreateInstance(args): Dynamic {
        var clazz: Class<Dynamic> = args[0];
        if(clazz == AnimationWithEvents) {
            return animation;
        } else if(clazz == BitmapNode) {
            return bitmapNode;
        } else if(clazz == AnimationController) {
            return animationController;
        }
        return null;
    }

    @IgnoreCover
    private function mockCreateInstanceWithArgs(args): Dynamic {
        var constArgs = args[1];
        return new TexturePackerJSONArrayFrameSpec(constArgs[0], cast constArgs[1]);
    }
}