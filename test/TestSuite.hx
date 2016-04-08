import massive.munit.TestSuite;

import animation.spec.TexturePackerJSONArrayFrameSpecTest;
import animation.SpriteAnimationControllerTest;
import animation.SpriteAnimationTest;
import animation.SubscribedAnimationManagerTest;
import collection.UniqueCollectionTest;
import core.ObjectFactoryTest;
import display.layer.RenderableLayerManagerTest;
import display.two.kha.Kha2DRendererTest;
import display.two.TwoDimDisplayNodeContainerTest;
import geom.RectangleTest;
import input.kha.KhaKeyboardInputSourceListenerTest;
import input.kha.KhaMouseInputSourceTest;
import sound.kha.KhaSoundHandleTest;
import sound.SimpleSoundManagerTest;
import sound.SoundLayerContainerTest;
import util.MappedSubscriberTest;
import world.two.GameWorld2DTest;
import world.two.ViewPort2DTest;
import world.TypeResolvedEntityFactoryTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(animation.spec.TexturePackerJSONArrayFrameSpecTest);
		add(animation.SpriteAnimationControllerTest);
		add(animation.SpriteAnimationTest);
		add(animation.SubscribedAnimationManagerTest);
		add(collection.UniqueCollectionTest);
		add(core.ObjectFactoryTest);
		add(display.layer.RenderableLayerManagerTest);
		add(display.two.kha.Kha2DRendererTest);
		add(display.two.TwoDimDisplayNodeContainerTest);
		add(geom.RectangleTest);
		add(input.kha.KhaKeyboardInputSourceListenerTest);
		add(input.kha.KhaMouseInputSourceTest);
		add(sound.kha.KhaSoundHandleTest);
		add(sound.SimpleSoundManagerTest);
		add(sound.SoundLayerContainerTest);
		add(util.MappedSubscriberTest);
		add(world.two.GameWorld2DTest);
		add(world.two.ViewPort2DTest);
		add(world.TypeResolvedEntityFactoryTest);
	}
}
