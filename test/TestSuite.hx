import massive.munit.TestSuite;

import animation.kha.two.Kha2DAnimationTest;
import animation.spec.TexturePackerJSONArrayFrameSpecTest;
import collection.UniqueCollectionTest;
import core.ObjectFactoryTest;
import display.layer.RenderableLayerManagerTest;
import display.two.kha.Kha2DRendererTest;
import display.two.TwoDimDisplayNodeContainerTest;
import geom.RectangleTest;
import util.MappedSubscriberTest;
import world.two.ViewPort2DTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(animation.kha.two.Kha2DAnimationTest);
		add(animation.spec.TexturePackerJSONArrayFrameSpecTest);
		add(collection.UniqueCollectionTest);
		add(core.ObjectFactoryTest);
		add(display.layer.RenderableLayerManagerTest);
		add(display.two.kha.Kha2DRendererTest);
		add(display.two.TwoDimDisplayNodeContainerTest);
		add(geom.RectangleTest);
		add(util.MappedSubscriberTest);
		add(world.two.ViewPort2DTest);
	}
}
